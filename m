Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4F84EADEE
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 14:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237076AbiC2M4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 08:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236960AbiC2M4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 08:56:25 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E148B25DA86;
        Tue, 29 Mar 2022 05:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=AItGskdKd8cHRwUBi5yZJ0huf1KiLM64DY3yzo0wmYw=; b=0YRjGWMtjc6njdk43NOcdUQHuA
        RFgSgFap6Qk7+VpnoheJgLmaQ5MLOzs/6t21Ms90FLEmC3ikkRjESBx4LTwJNxyoO17Gjo38TQOXU
        fBtIhpxePRQZcEpmeTT/e+4qEFB/PAdOLeWKJK+o1Zew+SM28YAY4kdaJpyJZAT7BEjU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nZBL0-00DAC2-4w; Tue, 29 Mar 2022 14:52:42 +0200
Date:   Tue, 29 Mar 2022 14:52:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        corbet@lwn.net, bpf@vger.kernel.org, linux-doc@vger.kernel.org,
        f.fainelli@gmail.com
Subject: Re: [PATCH net v2 03/14] docs: netdev: move the patch marking
 section up
Message-ID: <YkMBGm5bjHp/eZFq@lunn.ch>
References: <20220329050830.2755213-1-kuba@kernel.org>
 <20220329050830.2755213-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220329050830.2755213-4-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 28, 2022 at 10:08:19PM -0700, Jakub Kicinski wrote:
> We want people to mark their patches with net and net-next in the subject.
> Many miss doing that. Move the FAQ section which points that out up, and
> place it after the section which enumerates the trees, that seems like
> a pretty logical place for it. Since the two sections are together we
> can remove a little bit (not too much) of the repetition.
> 
> v2: also remove the text for non-git setups, we want people to use git.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
