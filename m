Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B02864141C
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 05:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbiLCEca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 23:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiLCEc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 23:32:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675C58D672;
        Fri,  2 Dec 2022 20:32:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01C9A60C58;
        Sat,  3 Dec 2022 04:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E527C433C1;
        Sat,  3 Dec 2022 04:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670041947;
        bh=mY6obiDD681p7cPcrw1nsdg1W5nnw4YZW8+hcL/SnKs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T6b33vpCepjNjucnYCi/+dCpvk2W3/nxPnP3KM0tdE+n6HDf++0GEYtKqK1tktY2o
         ScA00bc4mdXoM89vyRbePVdPl6nCTVabX0tb4b4xN4RqocD4LYXIgwctnrMfOzicnP
         KPOswHxvNyooiXW1mqnf1R8iCxvdl7saLPrQUXrpg9bThY5UkpzadEi9st3lw1q9f0
         2Aphy476/pwFPLrnTka8J7aEepc7Ol+0ucq2jcy5rfaxTB/N0gmQOAMMITFVZ66N8H
         swwmzdv4/9HKz9cJ9AlhIf27VTehEWfPplPbVe+4O+Tc1q/4x56Cf8LzoU9BAb+sCp
         sZrgTUUqWzfFw==
Date:   Fri, 2 Dec 2022 20:32:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: bluetooth 2022-12-02
Message-ID: <20221202203226.6feab9f5@kernel.org>
In-Reply-To: <20221202213726.2801581-1-luiz.dentz@gmail.com>
References: <20221202213726.2801581-1-luiz.dentz@gmail.com>
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

On Fri,  2 Dec 2022 13:37:26 -0800 Luiz Augusto von Dentz wrote:
> bluetooth pull request for net:
> 
>  - Fix regressions with CSR controller clones
>  - Fix support for Read Local Supported Codecs V2
>  - Fix overflow on L2CAP code
>  - Fix missing hci_dev_put on ISO and L2CAP code

Two new sparse warnings in btusb.c here, please follow up to fix those.
