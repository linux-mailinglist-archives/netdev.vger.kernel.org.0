Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332C24F21A3
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 06:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbiDECl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 22:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiDEClt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 22:41:49 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B74CBE71
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 18:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Lyi6oSuXtb8q3MRhOKWEH9l/ZdExCLs5NTfBMUP+DWA=; b=DtBWwC8Wfi2mpy8k7Cd8fjr1GR
        hOpNnSP3VF+I75/V8SD7RkO5Mg8FzmGZWDR/gb1nUsccA5wiYJEzMyIgNK9J6ue+fzeC6fL7OO2jv
        50iENr6kJcd/syOo2Wa124ftuZss2u1ObF1GxEpp9JnXKahJA0QRu1g04rn5GfLEcqIE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nbWhj-00E9xR-Le; Tue, 05 Apr 2022 02:05:51 +0200
Date:   Tue, 5 Apr 2022 02:05:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz
Subject: Re: [PATCH ethtool] ethtool.8: Fix typo in man page
Message-ID: <YkuH31rLTMuTWbdP@lunn.ch>
References: <20220404224005.1012651-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220404224005.1012651-1-vinicius.gomes@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 04, 2022 at 03:40:05PM -0700, Vinicius Costa Gomes wrote:
> Remove an extra 'q' in the cable-test section of the documentation.
> 
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
