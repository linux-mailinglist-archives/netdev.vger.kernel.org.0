Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619EA563830
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 18:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiGAQlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 12:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiGAQlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 12:41:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10354443E5;
        Fri,  1 Jul 2022 09:41:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B21C2B830D3;
        Fri,  1 Jul 2022 16:41:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28462C3411E;
        Fri,  1 Jul 2022 16:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656693693;
        bh=qoHlkWI1zxrRzZ/ONQiSR2Ievd6adZ7447as6XGDknE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rTL1qqcMMJ4t9mx5UP0nIfFcK0FtEFkvAZUQDDLSDfOMLaRlKXDgNooqYIJP9+6j8
         OkINxnM3CL2WdsINxn1uOFdU+og+SalOFaZOubBk0benBWPaDtKu30nd94zqNgJSnX
         ZQle4GH2ksVIL3QDkAj2kNrOxp3ld4iZiq0PFaUP0jFKev1Zp5xHx4h+YpAjDV+Uf2
         5gCjaL4lxJDCocz+0IhNTKF91d5hzFJUzRPBJs5wDIveEX2i7WSSH2C3UiK7HtnNWG
         CAlzOQsrn4vuymrnUGL89zwnMrN6twIPJex43Jm8exw7vOhlhIO+9iHP8UKV/uRJec
         Xwj+xQwDKNLGQ==
Date:   Fri, 1 Jul 2022 09:41:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: Re: [PATCH net] MAINTAINERS: add Wenjia as SMC maintainer
Message-ID: <20220701094132.18925f6f@kernel.org>
In-Reply-To: <20220701130253.854715-1-kgraul@linux.ibm.com>
References: <20220701130253.854715-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  1 Jul 2022 15:02:53 +0200 Karsten Graul wrote:
>  SHARED MEMORY COMMUNICATIONS (SMC) SOCKETS
>  M:	Karsten Graul <kgraul@linux.ibm.com>
> +M:  Wenjia Zhang <wenjia@linux.ibm.com>

Tab instead of spaces, please.
