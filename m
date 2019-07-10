Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7444E63EA1
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 02:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfGJAcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 20:32:46 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:32913 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbfGJAcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 20:32:46 -0400
Received: by mail-pl1-f194.google.com with SMTP id c14so261475plo.0
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 17:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9oGk0ncgBsleRAd52wOCv/WOL2t3HLvaZWnghim9pvM=;
        b=KezvgGx/1OGTcF0tnUluJi/bESJWb/FIKBa1sSHD2S6+soR9oe1po074LXBJ7mT2er
         tr9tEQqgoryG6yvrG9ngtZ7eYp/J7EA7GmWpCSc6IahTSepix07++PFrri+RK6asS+t3
         W5hI1XSWD9l/nxRcpgUwrX7pN/0SI6lifdFKb8LGnJpDGJkld98zaPqoMSjyp4ZolPtC
         LI8Z/iTDHMVEo2Co1ePjvmb7LdObb98i0+l8XGPj9QgQp9tsEpAjDq1eENdkWZ+8VROY
         s2cv40Q8x/ER95dD0ycRX6zR7sTMZ5wenGTD4kbE/PS7Rp8c5F/QDkFD305CAwSulfgy
         KBrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9oGk0ncgBsleRAd52wOCv/WOL2t3HLvaZWnghim9pvM=;
        b=gkeqAEmkyICnMgGLR+t7STJD/yamFa+SYADqSKKHytHYcHyjLoE64fnYFqoLvu0PLQ
         PqF1J9PY2APolcVOGriQMvM5M+qC5FL/+5if+jkmxohpme8479yUyeI0hw/AdPVRZ/5y
         nGS7dRpg+rKHUgR3XN74fJIfWo1EPauB7UrHgMOeA2CFV+KfFq8vFzIuwq9U0gTiVgw6
         xUB7v5C+OQpRzEcYxKsHkJA8KhNfIGCPKZbgMK0xnD3wcLKwUdgn9vv4p8z9WbEXJ8Y/
         dOcTFT+xq5WX6V75Axv6xM9S1p8L5HAbmWz2he7nVfZHUMyPlltoIy+eg0Q76KeK8RHA
         m6eg==
X-Gm-Message-State: APjAAAVfUrDPwBeshVnBSbn0j9CwFRQX7C8GdW4W0YYwQCx4v0UyolKg
        F6PLP75sVJzneOdXGkVP8ly8nw==
X-Google-Smtp-Source: APXvYqxr0ZXH5yAfPm187ZjSJ9RSAzFKjXCtMZjvCXQwp9V9fcPFl3mOT4MgqY9DHF6+bjpxLh7rPA==
X-Received: by 2002:a17:902:ba8b:: with SMTP id k11mr35402597pls.107.1562718765887;
        Tue, 09 Jul 2019 17:32:45 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id v184sm214439pgd.34.2019.07.09.17.32.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 17:32:45 -0700 (PDT)
Date:   Tue, 9 Jul 2019 17:32:43 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH iproute2 v2 1/2] tc: added mask parameter in skbedit
 action
Message-ID: <20190709173243.141160b1@hermes.lan>
In-Reply-To: <1562601978-3611-1-git-send-email-mrv@mojatatu.com>
References: <1562601978-3611-1-git-send-email-mrv@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  8 Jul 2019 12:06:17 -0400
Roman Mashak <mrv@mojatatu.com> wrote:

> Add 32-bit missing mask attribute in iproute2/tc, which has been long
> supported by the kernel side.
> 
> v2: print value in hex with print_hex() as suggested by Stephen Hemminger.
> 
> Signed-off-by: Roman Mashak <mrv@mojatatu.com>

Both patches applied
