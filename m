Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E65AA2F3B4A
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406358AbhALTz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390432AbhALTz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 14:55:58 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29E0C061575;
        Tue, 12 Jan 2021 11:55:17 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id x18so1985603pln.6;
        Tue, 12 Jan 2021 11:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=OHxfZefJp5DVb6I/g654zOX0kdQvKWlVA9tkXuzjllI=;
        b=E8p8MbbFOX87Tzd29VAlYQ94npIDgPk6BOQXPjg5q4rz9vI9cL5EgwkamLkQr2tp/t
         KTp7/g+3JZr5opWsE/zCm4OH9mrxWHUjLeGgvXlvsgvRG0gmOiaOqncJ2lD8WUn0FRH5
         omFHVaj5MzfxJq9YqJbGkuHqGVr89ATX3zTNkdGvheskX5UOLOB57HslDbdVhAI4hDVl
         8rvIiSDxPBOYv4GLsQYlzCkPERh2YGRR7Yrvoe+oxwzg+uf3rVmjAgfE3qb8SENG2qr4
         +4j3RhFhe9x8Bq9ZMRdz/8l1e9cxze8ec4R/ygNk5bJ1lc+aRDKsZl6sEl9DM1WymfAW
         ZTRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OHxfZefJp5DVb6I/g654zOX0kdQvKWlVA9tkXuzjllI=;
        b=ZRfL5HelAAGdv3yqjDJDrTJSzMOCN0DRxuG7peef5qrllVhHxKye9psy3TWzsrkWpv
         XABKILiqqgtFcO1KCefvnvluumbNtNGTZFWc0+6bMxur93FmqjP/XZbLisxhANNkZAna
         HFpor7Qm5g1pSgleTPrPbnCeMvhWLt1lRVsVJsQ1MzBENpTPAhG/m1ZQVHZvU7MtxiuI
         wS0L+C3kt8hW64H1Fx0Is6V3AphPAJHkxo6NRmfQjQSF2H2gwKemqE5Q8Hc36x3B2Ggu
         fjhvMHyyn7GTFXPvU7KmeqBMpuMBvpl9MNINHvamkpd3tzoL2QHKMFegUCPq+0Mw4ocv
         pxdQ==
X-Gm-Message-State: AOAM530BkR9lZnRY1H2ZoDICzg48DOm9nzPIbw1Yzbh4eWrsEzaxEvoz
        yF+gJaBuXiGWCroRMuIfjyhsgSzNpSD7
X-Google-Smtp-Source: ABdhPJyh4OgXheUX+DS6PXdtvQs2YW4vSjLZHQhggjATer9UQzyWYabHVV6R2AH78V8m5+hWE8XQ1g==
X-Received: by 2002:a17:90a:454e:: with SMTP id r14mr809933pjm.194.1610481317402;
        Tue, 12 Jan 2021 11:55:17 -0800 (PST)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id c62sm3874039pfa.116.2021.01.12.11.55.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Jan 2021 11:55:16 -0800 (PST)
From:   Praveen Chaudhary <praveen5582@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: RE: [PATCH v0 net-next 1/1] Allow user to set metric on default route learned via Router Advertisement.
Date:   Tue, 12 Jan 2021 11:55:11 -0800
Message-Id: <20210112195511.13235-1-pchaudhary@linkedin.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210111151650.41ac7532@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210111151650.41ac7532@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub

Thanks for the review,

Sure, I will reraise the patch (again v0i, sonce no code changes) after adding space before '<'.

This patch adds lines in 'include/uapi/', that requires ABI version changes for debian build. I am not sure, if we need any such changes to avoid breaking allmodconfig. It will be really helpful, if you can look at the patch once 'https://lkml.org/lkml/2021/1/11/1668' and suggest on this. Thanks a lot again.
