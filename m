Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DDB4E6BAA
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 01:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357089AbiCYBAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 21:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236251AbiCYBAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 21:00:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE32BBE16
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 17:58:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93ED5B82709
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 00:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5E3C340EC;
        Fri, 25 Mar 2022 00:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648169914;
        bh=MeuRRowCL/2XwzsQz5VVMTKBxOIJKapILagGpdlBRz0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NrYkYiySpLhhLF5L3/0GloOe1gKgNbFFtqrDcwK6QYxc7UrlVn/jiclwsoZE9ltxw
         rQ3H5iUTYJoIhSUERmgpYEzxTwX0XMNrQ+lV684WdTAJts1QT1L1VvaCq39vuN1k9M
         Uim++3DtHmsHAjzY8zInQK6NLIJF9gYHq4NMTATLC3fgCUnaOjr/gJIbo0/ISS+Hzi
         PyKShQRCO7KgNCxkg+3oY9x0QIHm6DKcpF4Fqy7XnAbkOOI1bat8IeVXZwQb7JNGKQ
         djO9DHiQARwjfdQfrKiE9getlQABYmJI5HefR3LFJc9ZnBL7Zw5BCOFZPPcvb4jAl+
         G0OzCiSVWhY9Q==
Date:   Thu, 24 Mar 2022 17:58:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     <davem@davemloft.net>, <andrew@lunn.ch>, <ecree.xilinx@gmail.com>,
        <hkallweit1@gmail.com>, <alexandr.lobakin@intel.com>,
        <saeed@kernel.org>, <leon@kernel.org>, <netdev@vger.kernel.org>,
        <linuxarm@openeuler.org>, <lipeng321@huawei.com>
Subject: Re: [RFCv5 PATCH net-next 01/20] net: rename net_device->features
 to net_device->active_features
Message-ID: <20220324175832.70a7de9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220324154932.17557-2-shenjian15@huawei.com>
References: <20220324154932.17557-1-shenjian15@huawei.com>
        <20220324154932.17557-2-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Mar 2022 23:49:13 +0800 Jian Shen wrote:
> The net_device->features indicates the active features of the
> net device, rename it to active_features, make it esaier to
> define feature helpers.

This breaks the build.
