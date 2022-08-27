Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F905A394A
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 19:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbiH0Rqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 13:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbiH0Rqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 13:46:42 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6966554E
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 10:46:41 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id t140so5819392oie.8
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 10:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=BPqX4WzEK0V9GD8kkM1lIz+Yp7xVAnZfR4ruEZs0njM=;
        b=DKilqngQSi2EImBQV8oM7lniOJeLEF6nBTaB4+igmV7y+Ygw5wsZLZYGPggH5mOUsM
         OE7RXOVx13HHtz4EH/ypqGouwkyX/mV21TlYjgVc+MPVOQEVSdTlW7uv8xG9T/KGBsh4
         fvCOgRvJLHbJvpUyA/YdoUhUBJK/a2okZoCUginJ4xdXDJxuoR6BQ82WR4qBcDlLnOzn
         EZOJ1mmBJRPpycSd+d7fnB9nS8khtlH8JXuegPH1PSJmtS4Dut7B0BWccEdo3WBu2MEb
         w11o1Xty4fhDM2epAfsVf3AHLhYuOhC2ZFRjsai9YXnzR5GrcFsph7jikwGskdaD0SpF
         sdyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=BPqX4WzEK0V9GD8kkM1lIz+Yp7xVAnZfR4ruEZs0njM=;
        b=kFSB76gjYU3cfDfjuQrupuc+MYDWLysRMU4OgZFl7dCzOSsGIQThRMgpxE2EbTXfzL
         /1D++2X0VsyEcrx/1C12eV8jsD26j7A5WomFD1Iim1pox+E0ub411BrRxraO4ihEA0mE
         /166m92JEtTfhGbl9RbCs1yQBb97BCrQk2zfZ0bK42TmSo4dWcLh9lGJj2XZXT4EnBRb
         GkUz2LCu8hZP2OOuK2Fyas7jYnhPJFUtAduuNJ+RmNOdusLspWT1zsquvcqPSyugVXw0
         XGisnmylo80t48OdULNYjTSaCJutEXHSo5cuAi2FZ79VmPUKBvtvjWsG46RLEKmwHpM0
         eX0Q==
X-Gm-Message-State: ACgBeo0Qd+vsrU7gEU1V84gG8+QN7KLtWJdYWuTaIfZH61xIUv7pFzC/
        3hvQvpvBiuBvA4m9+NYNFBXAuApWPJo=
X-Google-Smtp-Source: AA6agR5fAJMOu0Nt0o3Keay72CSf0lPZggJVm6lJQGtuC2L848UZ3WokP5ib6sJFvPDQj/8RizmqIw==
X-Received: by 2002:a05:6808:1384:b0:343:4570:b68d with SMTP id c4-20020a056808138400b003434570b68dmr3876678oiw.35.1661622400826;
        Sat, 27 Aug 2022 10:46:40 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:e448:c1ce:ae49:d00c])
        by smtp.gmail.com with ESMTPSA id t9-20020a056871054900b001089aef1815sm3279542oal.20.2022.08.27.10.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Aug 2022 10:46:40 -0700 (PDT)
Date:   Sat, 27 Aug 2022 10:46:39 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     =?utf-8?Q?Jaros=C5=82aw_K=C5=82opotek?= <jkl@interduo.pl>
Cc:     netdev@vger.kernel.org
Subject: Re: Network interface - allow to set kernel default qlen value
Message-ID: <YwpYf0/0q0V9TFFM@pop-os.localdomain>
References: <6cb185cf-d278-9fde-40c9-12b24332afc8@interduo.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6cb185cf-d278-9fde-40c9-12b24332afc8@interduo.pl>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 10:41:40AM +0200, Jarosław Kłopotek wrote:
> Welcome netdev's,
> is it possible to set in kernel default (for example by sysctl) value of
> qlen parameter for network interfaces?
> 
> I try to search: sysctl -a | grep qlen | grep default
> and didn't find anything.
> 
> Now for setting the qlen - we use scripts in /etc/network/interface.
> 
> This is not so important thing - but could be improved. What do You think
> about it?
> 

I have to ask, what is wrong with setting it in your ifup script after
it is created/probed?

