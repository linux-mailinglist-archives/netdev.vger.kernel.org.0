Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD694D296A
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 08:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbiCIHYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 02:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiCIHYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 02:24:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCD28C7F9;
        Tue,  8 Mar 2022 23:23:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C373661985;
        Wed,  9 Mar 2022 07:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B79CC340E8;
        Wed,  9 Mar 2022 07:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646810601;
        bh=4vUqzSLxU7s7Wud0FXo8FM5vWbg7fksL1QMOdfnMzo4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=cKUmU7FnVEuzwTgINFLniaG5G4O0ir31nOAXpsZ4fgg0LgQvea5EG0ro1aIMKafPJ
         t5IPK2okseBTM3e0r8z+a+/gDgY6lRzHR631qWNICGHO5bNGKL52oq0VG1wiyZDcx/
         iasN359v1dLK3SJGdbcui79YIkOPCr5BT8ybDvX8G64mlEe55E41m5+O17zJL0zUyo
         Ji0W7xmq7MbaPRM5dC819t5hlEN0u0GQbaOyAWKbhBP76I+3kljhL+if+lTvpW0NDx
         v0UEQiZZoGnSk1xOJ4WLgxvMPISMUeqUZe55zN2eTtZxZS6WGuh7hCsW2dIf4oGCL/
         zzgyhBQL//0Xg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jeff Johnson <quic_jjohnson@quicinc.com>
Cc:     Miaoqian Lin <linmq006@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rakesh Pillai" <pillair@codeaurora.org>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix error handling in ath10k_setup_msa_resources
In-Reply-To: <b69308a5-0d29-6b48-833c-f3eacfe03b08@quicinc.com> (Jeff
        Johnson's message of "Tue, 8 Mar 2022 16:05:09 -0800")
References: <20220308070238.19295-1-linmq006@gmail.com>
        <b69308a5-0d29-6b48-833c-f3eacfe03b08@quicinc.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Wed, 09 Mar 2022 09:23:16 +0200
Message-ID: <87a6dzsi6z.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jeff Johnson <quic_jjohnson@quicinc.com> writes:

> On 3/7/2022 11:02 PM, Miaoqian Lin wrote:
>> The device_node pointer is returned by of_parse_phandle()  with refcount
>
> Kalle, can you fix this nit when you apply?  remove extra space after ()

Will do, thanks.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
