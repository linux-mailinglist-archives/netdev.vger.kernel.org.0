Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D35682FE0
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbjAaO4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbjAaO4e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:56:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FE551C43;
        Tue, 31 Jan 2023 06:56:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65041B81D38;
        Tue, 31 Jan 2023 14:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4014C433EF;
        Tue, 31 Jan 2023 14:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675176988;
        bh=r9f3CO6stuYfSV8PBSzgXoL9tTULU6Lb2hADDhpOq5Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=klXKEiNPo6g9bBvrG+jqs1lhblWW6a2IBUUuqZT3dNRiBeGU+h5gvyGuIarw5iTUy
         rrds7ISbKCSCKOKqYAIiXBfKjcnpxns0Dd+W8Z5qJIs1WfadQJZ2B5MnIT7NXS0AX3
         PrZeazYkuK2OZjpeTo81kKIbdZKg62PCmJmBCPz0=
Date:   Tue, 31 Jan 2023 15:56:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Miko Larsson <mikoxyzzz@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net/usb: kalmia: Fix uninit-value in
 kalmia_send_init_packet
Message-ID: <Y9ksGXzP4vPDFiU3@kroah.com>
References: <7266fe67c835f90e5c257129014a63e79e849ef9.camel@gmail.com>
 <f0b62f38c042d2dcb8b8e83c827d76db2ac5d7ad.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0b62f38c042d2dcb8b8e83c827d76db2ac5d7ad.camel@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 03:20:33PM +0100, Miko Larsson wrote:
> syzbot reports that act_len in kalmia_send_init_packet() is
> uninitialized. Fix this by initializing it to 0.
> 
> Fixes: d40261236e8e ("net/usb: Add Samsung Kalmia driver for Samsung GT-B3730")
> Reported-and-tested-by: syzbot+cd80c5ef5121bfe85b55@syzkaller.appspotmail.com
> Signed-off-by: Miko Larsson <mikoxyzzz@gmail.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
