Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1A963B159
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbiK1ScN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbiK1Sb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:31:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA45AE44
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 10:27:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E09061374
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 18:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7507C433D6;
        Mon, 28 Nov 2022 18:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669660031;
        bh=7wZQixCdl9hH/qcNu8Q2k7mtijU0UnXYeO1PY9MZGkY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ICnfE34ojeUnK1Hf20dSlFt3snP3VtJFRbNs3ZSdDXHtWu0HinUri2tDkPxmYcQKd
         SUhcyn+qVvfcbsqYj4DBYhmy/z+zEgMlkFs6o2X6zMtFLphOVzRvOMbm1MIANhO/1X
         ARDoHdx9lYuinTTifCtp1spV9IfObRuIWzyaFtyZU/iyP53jS52oFzi732NxOxqioO
         lVj37TLiklG2RzgGEnmmqzEMFTPYOp60KJX8u+xYmiqZB0oSbl5YbMSIW+Ukejop4J
         r26Vt8wew//g7I6iHtAvMmBGhtmqZlnH3xfwSfasjYVjhHzeaUPK0Yp961SuudxZ8m
         hycltSB48J+gw==
Date:   Mon, 28 Nov 2022 10:27:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        drivers@pensando.io
Subject: Re: [RFC PATCH net-next 06/19] pds_core: add FW update feature to
 devlink
Message-ID: <20221128102709.444e3724@kernel.org>
In-Reply-To: <20221118225656.48309-7-snelson@pensando.io>
References: <20221118225656.48309-1-snelson@pensando.io>
        <20221118225656.48309-7-snelson@pensando.io>
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

On Fri, 18 Nov 2022 14:56:43 -0800 Shannon Nelson wrote:
> Add in the support for doing firmware updates, and for selecting
> the next firmware image to boot on, and tie them into the
> devlink flash and parameter handling.  The FW flash is the same
> as in the ionic driver.  However, this device has the ability
> to report what is in the firmware slots on the device and
> allows you to select the slot to use on the next device boot.

This is hardly vendor specific. Intel does a similar thing, IIUC.
Please work on a common interface.
