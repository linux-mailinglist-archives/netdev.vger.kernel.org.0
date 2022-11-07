Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59D6361F855
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 17:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbiKGQGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 11:06:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbiKGQGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 11:06:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4AB201AB;
        Mon,  7 Nov 2022 08:06:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DB96B812A8;
        Mon,  7 Nov 2022 16:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C25C433C1;
        Mon,  7 Nov 2022 16:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667837166;
        bh=QEeTPjTTUhlRPhDXz1hYJehaOMwD4NwQVKrn8Tqo/tA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gX9ZlDCOd3itoUufEUVTX3zrIQF5O/FCFl3WsB4p9ntW4uVEdXNBRdZJYyUVUXQCf
         2JQnkrdsML2CRYLPfFSNLwWNxLjQZhtdGRITKj+oQeTxFO5v4M9PGf1oPxvswJoUfy
         R1NdhSXUlgmyXTKMMU6z52Sh+xZbkN43IhVj08sV836YWlCFRAwL4eaHaIyi7EWyhF
         C0nkUYtPgIDh3vfHV7krZF2emg0yYTQNXBnO57ysllNWjzf7n3i8WLX5rxfi9fjNaJ
         biJGI9/rY7FzH2rl7nVnsxiM1UlCMmInTcJF33LrHg0j6M74r0bJpqTbuqguN8Acqm
         KocMVFLHKd9Iw==
Date:   Mon, 7 Nov 2022 08:06:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Ajit Khaparde <ajit.khaparde@broadcom.com>,
        andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, michael.chan@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        selvin.xavier@broadcom.com
Subject: Re: [PATCH v3 0/6] Add Auxiliary driver support
Message-ID: <20221107080605.35ef5622@kernel.org>
In-Reply-To: <Y2inmdbpoRm2VbuE@unreal>
References: <CACZ4nhtmE9Dh9z_O9-A934+q0_8yHEyj+V-DcEsuEWFbPH6BGg@mail.gmail.com>
        <20221104162733.73345-1-ajit.khaparde@broadcom.com>
        <Y2inmdbpoRm2VbuE@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Nov 2022 08:37:13 +0200 Leon Romanovsky wrote:
> Please send this series as standalone one and not as a reply
> to previous discussion. Reply-to messes review flow, especially
> for series.
> 
> Jakub, I'll review it once Ajit will send it properly.

IIUC we wait for you or Jason to review any of the RoCE bifurcation
patches before considering them for inclusion.
