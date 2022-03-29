Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014CA4EADF0
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 14:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236960AbiC2M5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 08:57:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237037AbiC2M4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 08:56:45 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6656225C64;
        Tue, 29 Mar 2022 05:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=1Mlt4jgKjj/rNLkdgKpc8EIxOQq5LjjUIgForipMaQw=; b=mzESZkgLu1hlfrCMYVyR7tdyQM
        J7zzm+wV36G9QDXIMRUFSO0yB0OAQaG9LpN3XKrftsPkelQWQPFTiFLOolHc4AcEO8PeQbUuq9DDT
        WRHthaildAR+wzz6MBHQKa97y0gBlCUKCMpZUvtpQwDL6RtvdPntF3VR/0tWQHSNCIcw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nZBLW-00DACi-Df; Tue, 29 Mar 2022 14:53:14 +0200
Date:   Tue, 29 Mar 2022 14:53:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        corbet@lwn.net, bpf@vger.kernel.org, linux-doc@vger.kernel.org,
        f.fainelli@gmail.com
Subject: Re: [PATCH net v2 05/14] docs: netdev: note that RFC postings are
 allowed any time
Message-ID: <YkMBOhF3csCOxMIu@lunn.ch>
References: <20220329050830.2755213-1-kuba@kernel.org>
 <20220329050830.2755213-6-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220329050830.2755213-6-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 28, 2022 at 10:08:21PM -0700, Jakub Kicinski wrote:
> Document that RFCs are allowed during the merge window.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
