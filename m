Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E38655F41
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 03:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbiLZCnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Dec 2022 21:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiLZCnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Dec 2022 21:43:10 -0500
Received: from cavan.codon.org.uk (irc.codon.org.uk [IPv6:2a00:1098:84:22e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F25C26CD;
        Sun, 25 Dec 2022 18:43:09 -0800 (PST)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
        id EAF6A424AA; Mon, 26 Dec 2022 02:43:07 +0000 (GMT)
Date:   Mon, 26 Dec 2022 02:43:07 +0000
From:   Matthew Garrett <mjg59@srcf.ucam.org>
To:     Lars Melin <larsm17@gmail.com>
Cc:     johan@kernel.org, bjorn@mork.no, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Matthew Garrett <mgarrett@aurora.tech>
Subject: Re: [PATCH 1/3] USB: serial: option: Add generic MDM9207
 configurations
Message-ID: <20221226024307.GA12011@srcf.ucam.org>
References: <20221225205224.270787-1-mjg59@srcf.ucam.org>
 <20221225205224.270787-2-mjg59@srcf.ucam.org>
 <10cff30a-719d-f6b0-419c-36c552f4bc4b@gmail.com>
 <20221226020823.GA10889@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221226020823.GA10889@srcf.ucam.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,KHOP_HELO_FCRDNS,SPF_HELO_NEUTRAL,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 26, 2022 at 02:08:23AM +0000, Matthew Garrett wrote:

> Do you have a pointer to that driver? That seems consistent with the 
> Windows drivers, but I have no experience with that.

Ah, it looks like the qcmdm driver is actually just an alias for the 
serial interface, so including that here seems reasonable. I've only 
included devices I can verify, but if you like I can just turn the whole 
.inf data into IDs here?
