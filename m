Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF1638052A
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 10:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbhENI2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 04:28:07 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:43457 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230459AbhENI2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 04:28:06 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id 556B9580E50;
        Fri, 14 May 2021 04:26:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 14 May 2021 04:26:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=daR/M5MALqqc200eLyQkU6f/JMT
        STdMzWTRNACNiQw4=; b=k4GcSF5jp6KuVfMXBuyqOgjNsDg8Ca9pvOJZQM/qJT0
        Da6sqGhNt27t1UsZWpgLPURjiT3gDNTMwAxeSa7orl715t2qYJHdlde0L/znl+9m
        GwdsyUBcxbnJavIhbtuW44HsF43RFFh99BTLYNTM4pzAFf6XgSl81O0Mv5UnJcBH
        A2Or/96PbExkUd8MgusNZUdtNJdEizEpjsIcGfSLdx5bcNRYLiz2qUVBHF3Mn8EL
        P6sg+Rl8EctdfENO+I+jDz9HKD+8cgedRWDA8BuwY8MI0xCIgW+EY77/ov+z1a3u
        fwpcvnWniLW0FMgIz/Lqr4lgJPH2x6a6JR2aPkfamEw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=daR/M5
        MALqqc200eLyQkU6f/JMTSTdMzWTRNACNiQw4=; b=bo/Ua6DozGeIGmITh9k9Id
        5Q1unfPHaWNc/hsY36psAXHgRUCp3HfLey3x+jM9gSQ1qKFxfpYBk8kP1nnp4+mF
        fDL6BsboNbc4u/F2opK9yNGDUEeDorFIFO3tiHL25PnGobFB47Trl/U1AB3mCWAr
        kr3rdwdoS3KXNI2+T9UUgZg/JihJffXzXSLeVE1zkePsm50YTLTWh9yoLRoipD4X
        UqItxgT+Wp46cxMJHmqbmvcJioXVua7RGXCe6SWq3ImMh0iZ/2vTl5MHHyd0rCKW
        bpZTDbNZKnRBDuHhzCZYRedAkhW84MSKyHPMwfBNjGDeQbp5YHTTSJ9qBRqpBbKQ
        ==
X-ME-Sender: <xms:TjSeYJtd9meb5NaHEKAtelePkAKapXwGgyR9D1Ng6Eo3yGbuPpyTvw>
    <xme:TjSeYCc52ZjBZtKVSj281lFXyYO6pgy_vuMj3ielpigRaLKq4_6t8j4c05BUHkWvO
    G156ayD1hrOkw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehhedgudefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:TjSeYMy3Krfgm5GPO85Gn2BG4pNgXLIirSR7V4-DZwfFOzUVx3W5iQ>
    <xmx:TjSeYAP2RPsjOP13qy4fbp23D8yXVIUqdlO1mdmYS7ye0GAEdMoPuA>
    <xmx:TjSeYJ81a5JyFL_lVHp0CbL2Cqy-19dVo3MLc9LhuktNVs_a7pfLdw>
    <xmx:TzSeYOjjGabp7Z_KJLtpHYFXTZe8M8YLifp_Rig0OcnNrmDG3WaRow>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri, 14 May 2021 04:26:54 -0400 (EDT)
Date:   Fri, 14 May 2021 10:26:51 +0200
From:   Greg KH <greg@kroah.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        syzbot <syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        nic_swsd <nic_swsd@realtek.com>
Subject: Re: [syzbot] WARNING in rtl8152_probe
Message-ID: <YJ40S1eHnbg1dsYv@kroah.com>
References: <0000000000009df1b605c21ecca8@google.com>
 <7de0296584334229917504da50a0ac38@realtek.com>
 <20210513142552.GA967812@rowland.harvard.edu>
 <bde8fc1229ec41e99ec77f112cc5ee01@realtek.com>
 <YJ4dU3yCwd2wMq5f@kroah.com>
 <bddf302301f5420db0fa049c895c9b14@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bddf302301f5420db0fa049c895c9b14@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 07:50:19AM +0000, Hayes Wang wrote:
> Greg KH <greg@kroah.com>
> > Sent: Friday, May 14, 2021 2:49 PM
> [...]
> > Because people can create "bad" devices and plug them into a system
> > which causes the driver to load and then potentially crash the system or
> > do other bad things.
> > 
> > USB drivers now need to be able to handle "malicious" devices, it's been
> > that way for many years now.
> 
> My question is that even I check whole the USB descriptor, the malicious
> devices could duplicate it easily to pass my checks. That is, I could add a
> lot of checks, but it still doesn't prevent malicious devices. Is this meaningful?

Checking the whole USB decriptor is fine, yes, they can duplicate that.
So that means you need to validate _ALL_ data coming from the device
that it is in an acceptable range of values that the driver can
correctly handle.

thanks,

greg k-h
