Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9686F210C
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 00:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346637AbjD1Wv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 18:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjD1Wv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 18:51:59 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C181D26A5;
        Fri, 28 Apr 2023 15:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sEDkNTAnH5SRf789MEV0Ur5N7kWRpsBcsFrNb8ebyM8=; b=Hr0crz/0BUWnb5vJjikin3+UPy
        /eAAB/2ovVNICJRgxWNFchulbzgyodK7idd2fXM6WahDv4xUtcYlBohUOGfKisfoXkz4PpiBnJbQo
        etLtnSk8mZZPdLiJim4+GE35bw4xmeas6241qGMSXjuDy5ZiOLZjvWNCPb4Gwvwy8yRw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1psWwS-00BTH2-9w; Sat, 29 Apr 2023 00:51:52 +0200
Date:   Sat, 29 Apr 2023 00:51:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        netdev-driver-reviewers@vger.kernel.org
Subject: Re: [ANN] netdev development stats for 6.4
Message-ID: <4d47c418-32d9-4d6a-9510-a6a927ebe61b@lunn.ch>
References: <20230428135717.0ba5dc81@kernel.org>
 <667f3a20-aaa3-edd6-8769-7096649c5737@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <667f3a20-aaa3-edd6-8769-7096649c5737@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Can you give a little more description of what is being measured in this
> section - is this reviews versus submissions?  And what are some ways for a
> company to get out of the wrong list?

Good citizens should perform code reviews as well as submit code. So
yes, it is reviews versus submissions. If you look at previous
versions of this report there is more details about the calculation.

Microchip has done exactly that, gone from the bad side to the good
side. And they did it by a couple of their engineers performing
reviews.

	Andrew
