Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE482F7407
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 09:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732268AbhAOIJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 03:09:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbhAOIJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 03:09:43 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46182C061575;
        Fri, 15 Jan 2021 00:09:03 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id h186so5014311pfe.0;
        Fri, 15 Jan 2021 00:09:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=FiTUf7nc7yy9jR7tyMkjzq+KmoD8V4MoKYuzDq3AhDs=;
        b=bRN84fqhW3ZLZOOrZ4/bA/aFz+50ftrD79WDwxox3efELymGM6/g+24Aoqp3K9oh+m
         sWv4UFodQT80J5nYwrXZ96juDo6PRaMYaS7V0F71Xe3mvDxlinHAwJDQ7SY7FIUDfuU4
         eUjwDwiaYKZ8EVhjE/AqLPRe9tXvqsofIVtc138nB5qbUvE2p7QBvJLDio7ZDVert6Um
         +iHJxfVT5T3k6MrOg+x7Hgbn4k8k26ieZQhkpHxkYkq6e5gZRLNLIjDeIfoFOvgAG+tQ
         SHrA/6MmU6r5DCHqpn3U25pChQ0e2UzH/ZfBjwjM3QFgDvepuWs4qIfWzXBxafQAyHM6
         HP3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FiTUf7nc7yy9jR7tyMkjzq+KmoD8V4MoKYuzDq3AhDs=;
        b=h7vVrjd07GmNtCvztq4m+OhrDAEeoSJo4z9uP8Z0GRrXNJ7h1pPOKO5v2adBTyOx8p
         Nvq2YBz9CWESZ3X62luy6IJwsXQfUV00khN17cOBXT/uoCc95GIEum8IrSFt9whYdH2l
         0brqc/SZQYXsj3+0/B3lkzUCuzROEMxVIyPFKQwazQtYmKGm8+IbTt8e7GQAD0Qupl+g
         RueclLBKF7NINeDNJrmwKbEcDp6mOQmdOtVt4GtUTjWwHP0ie11IERYPg2hiFXoVU/49
         umk/SfbLXGNkCZdcNW72BmI+E3OLA/CCwkxZjdaARLBrxWY7al9spJdfvAgZ8UfgAA0K
         HxiA==
X-Gm-Message-State: AOAM533ia/NiqXfICOwQn8U7Uf+aEhXjj+iO8Ru5GSZ1eQCJfHVFkQq+
        Q/Dr6qY4dMu7JVf0SuwjZKlFP5NHGSji
X-Google-Smtp-Source: ABdhPJyKOtSp/IgI/0Q8VQm9IhylA/Ykto/CggxRuIoDNfWraZRWfxqxO8Gx0H7QWtbL3+sxX1AmQA==
X-Received: by 2002:a62:c504:0:b029:1a5:b198:18dc with SMTP id j4-20020a62c5040000b02901a5b19818dcmr11327505pfg.79.1610698142869;
        Fri, 15 Jan 2021 00:09:02 -0800 (PST)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id x14sm7342534pfp.77.2021.01.15.00.09.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Jan 2021 00:09:02 -0800 (PST)
From:   Praveen Chaudhary <praveen5582@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: RE: [PATCH v1 net-next 1/1] Allow user to set metric on default route learned via Router Advertisement.
Date:   Fri, 15 Jan 2021 00:08:57 -0800
Message-Id: <20210115080857.8978-1-pchaudhary@linkedin.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <e894509c-e081-3682-7cc4-a20812f41984@gmail.com>
References: <e894509c-e081-3682-7cc4-a20812f41984@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David

Thanks a lot for Review,

I have raised v2 after addressing your review comments from
https://lkml.org/lkml/2021/1/14/1400.

List of changes in v2:
---
1.) Replace accept_ra_defrtr_metric with ra_defrtr_metric.
2.) Change Type to __u32 instead of __s32.
3.) Change description in Documentation/networking/ip-sysctl.rst.
4.) Use proc_douintvec instead of proc_dointvec.
5.) Code style in ndisc_router_discovery().
6.) Change Type to u32 instead of unsigned int.
---

Thanks a lot again for help.
