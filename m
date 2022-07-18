Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011B0578D22
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 23:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbiGRV5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 17:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236377AbiGRV5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 17:57:30 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB6F29824
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 14:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/GUKY8t7Rig5FlkSMoRDOwIBaUcgXXruAHffjPfcvio=; b=B/C644TTTTnloOTaLW0AWovR0o
        KBiSvnWuAvSs1OhboyKwzlw1cHh4EYnqMCFBNdy6S54MEeAEC09Yp0dx+DD1vGghY2xjTXc3H5hVi
        J+lQLfulfMlbxDn3MUXgs40cJNrVhLXnMzF1ORa4F6jdsk7p6Bkl0TuiELS8F5O33+lo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oDYk1-00AlIc-P3; Mon, 18 Jul 2022 23:57:25 +0200
Date:   Mon, 18 Jul 2022 23:57:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andrey Turkin <andrey.turkin@gmail.com>
Cc:     netdev@vger.kernel.org, Ronak Doshi <doshir@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Subject: Re: [PATCH v2] vmxnet3: Implement ethtool's get_channels command
Message-ID: <YtXXRVzQVd3892mc@lunn.ch>
References: <20220718045110.2633-1-andrey.turkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718045110.2633-1-andrey.turkin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 04:51:10AM +0000, Andrey Turkin wrote:
> Some tools (e.g. libxdp) use that information.
> 
> Signed-off-by: Andrey Turkin <andrey.turkin@gmail.com>

This looks nice. For code style:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
