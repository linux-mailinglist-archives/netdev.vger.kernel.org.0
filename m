Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76AC26B9D1E
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 18:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjCNRd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 13:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjCNRdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 13:33:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089E752F76
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 10:33:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57CE661851
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 17:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B4FC433EF;
        Tue, 14 Mar 2023 17:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678815198;
        bh=a+TKH6vKYxt9Rf6imnGNYlq/WxGjutqwdl6qFeqcGf8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DCEMKlCVtkzH5V4m/coVlPX3yyaNb67eNLnf0VMTImVFCRrveWB1ECPOmaXdrrag2
         swEYz46koz4lviXIPn1nkJD0XZHGO4L7yMlte2N/+mb1EyZpYH6gz9AOOLK+uGLQ4j
         zisxrEbiwJvQQs4isTHo/gweB+HFHzpsr5BlQ4LFzyzXszx6Mufj1PojRgNsPuGJKC
         OMIWh2k2B1+4HFTrYouonUU77LxufogpE+kq3V/443L4HXM6Yh/iPcd0RnbvrOqcVU
         2tc81h822PBz7ePe6Araj/8+ufG+nkHTd7rmdyYqS9evQzp91bkpIg9VcEfg54FnZs
         JDn/eubkRifog==
Date:   Tue, 14 Mar 2023 10:33:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: Re: [PATCH net 00/13] net: stmmac: Fixes bundle #1
Message-ID: <20230314103316.313e5f61@kernel.org>
In-Reply-To: <20230313224237.28757-1-Sergey.Semin@baikalelectronics.ru>
References: <20230313224237.28757-1-Sergey.Semin@baikalelectronics.ru>
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

On Tue, 14 Mar 2023 01:42:24 +0300 Serge Semin wrote:
> From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

We don't feel comfortable accepting patches from or relating 
to hardware produced by your organization.

Please withhold networking contributions until further notice.
