Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91AD0DFC80
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 06:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730784AbfJVEWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 00:22:53 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46019 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729133AbfJVEWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 00:22:52 -0400
Received: by mail-pl1-f194.google.com with SMTP id y24so3757799plr.12
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 21:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=aXqwPh4E6baIh1p/Lki8QmuQiEfymckTaQYi0lg2PDg=;
        b=AnZdr1KAV3+zDeoARr9MK+jZwB0SnPHPrDk3zTcTgE4Pd3+2rdGW7eWcN3zjCBSNgk
         V3AdUEJu6RuZ6hcaAduwTbGSFvejHEeZuywAJnaLJ0k5gtlAkBwbzjbSvisZ+BRJZ337
         sExV8KFL2XEWxi6EsZ5DG7QGXs0Hg/vOvmzWqDSWNmdwnmp4NuNqrCqOXNJgVIGH0yfF
         1anp0Jt6VpUQ67+C96uScQ+BM2bTAy7prnngimDtpWMvCCDmy0TD3UzrdTmhZXCLq1z3
         WZamAL0mjYa0/Dodzr3cpxZNa5DY+bPDk1EIl1YnMlB7UiPfn1zIFnq+/9lT3HoWMGu1
         AS8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=aXqwPh4E6baIh1p/Lki8QmuQiEfymckTaQYi0lg2PDg=;
        b=Nj4FEThEx+ZXMw8czz364ggWDkBVopwWxePY9LZ3L/hdiR4b7eHOD1p/UxNqv3Hgso
         JidMgfPUuVkuaAKbU4Fx/0wsQBgbMYyxdjfoDs0LZNS6fQ8EC7aXwEeFdWo5qN600rZc
         RAxczE4mPC3n32UB6E8Tug4rS/QYsAZQQyUfcvGpsQgZqUP71SjpmoS4J37IUxUnEK2Q
         1Lx/0VdY2kDAbMulsLksP8PsfBsSF7JQ6wN/Zut2l4GtDikefCYzKAKQQjCxiRdmGSeJ
         Zz2uNCmJBIorWWpTje3OJaxzce7pXWFJQV8ipUwyYMAf9GFewGFfij8gYZU+T9nocA72
         GhTQ==
X-Gm-Message-State: APjAAAVltUp1LIFkuYUTgqEt7mmpjDNinhzm8J9ilFY94+KuSFn4qvFB
        Jxq7dafq+y0hP+hOtdrW/lHUxA==
X-Google-Smtp-Source: APXvYqzgpalTKybCMuyjL8wAcuf0MMupdxBNAD7leznk5WaTWdNWsKhnWt5IVieSVobjrqe+HBUebA==
X-Received: by 2002:a17:902:8642:: with SMTP id y2mr1479883plt.187.1571718170798;
        Mon, 21 Oct 2019 21:22:50 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id 30sm17208412pjk.25.2019.10.21.21.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 21:22:50 -0700 (PDT)
Date:   Mon, 21 Oct 2019 21:22:48 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Madalin-cristian Bucur <madalin.bucur@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roy Pledge <roy.pledge@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: Re: [PATCH net-next 5/6] dpaa_eth: change DMA device
Message-ID: <20191021212248.0f2d5f57@cakuba.netronome.com>
In-Reply-To: <1571660862-18313-6-git-send-email-madalin.bucur@nxp.com>
References: <1571660862-18313-1-git-send-email-madalin.bucur@nxp.com>
        <1571660862-18313-6-git-send-email-madalin.bucur@nxp.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 12:28:02 +0000, Madalin-cristian Bucur wrote:
> The DPAA Ethernet driver is using the FMan MAC as the device for DMA
> mapping. This is not actually correct, as the real DMA device is the
> FMan port (the FMan Rx port for reception and the FMan Tx port for
> transmission). Changing the device used for DMA mapping to the Fman
> Rx and Tx port devices.
> 
> Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
> Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>

Curious, we also have a patch for fixing this for IXP400.
Is there something in recent kernels that uncovers this bug?
