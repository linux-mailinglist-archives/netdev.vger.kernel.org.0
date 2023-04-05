Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89DA6D89D2
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 23:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbjDEVwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 17:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbjDEVwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 17:52:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FCE7A9E;
        Wed,  5 Apr 2023 14:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=LScejSnKVmf7CU04bLobpq4pmCvo4nz8BSOaDO7zToI=; b=HUB34vqaLxpQt+ZB38q3jl38dx
        yOsKgo70Zjx3ObFHzQYzMP78h9+8kELN/zBHJGkPbvA0rcgb7SGUzEV/nvO9E6OlOhPKSvgYyjlrf
        FUZROqdAzl8uIRAG626slb2YZTMWhI5fGDeAwXZkZ8M/wUFtE7GCByPnh0eRgdX20QlVa/Kcoxkv5
        1oqYZ4jgDwD5Z+NhhMuLRNpeKSEfakRl3JN9SXz1kfBz5hcuMGfv5YWBts2EEfs7CKQ8VxMZI40LH
        WteNBxg8VYLdJ2c95yEA8dXZRDzJjIzrjKI8KD/5Mva6kV1tYONLSI2kOR2X3De6qcJYV36HX7Tw5
        M0elcIag==;
Received: from [2601:1c2:980:9ec0::2764]
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pkB3d-005mlq-02;
        Wed, 05 Apr 2023 21:52:45 +0000
Message-ID: <86e707d3-8d69-331b-9a07-148559eae4f5@infradead.org>
Date:   Wed, 5 Apr 2023 14:52:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: Missing macvlan documentation
Content-Language: en-US
To:     Hadmut Danisch <hadmut@danisch.de>, linux-doc@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>
References: <3fca7d35-8d79-8181-b00d-d35824106b5d@danisch.de>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <3fca7d35-8d79-8181-b00d-d35824106b5d@danisch.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 4/5/23 13:26, Hadmut Danisch wrote:
> Hi,
> 
> 
> docs.kernel.org has a page about the IPVLAN network driver at
> 
> https://docs.kernel.org/networking/ipvlan.html

That just contain what is generated from the kernel source tree.

> 
> which even refers to the MACVLAN driver, but there is no page about the MACVLAN and its options. Quite difficult to find reliable documentation about the macvlan driver and modes.

This is really an issue with the networking documentation, so
Cc: netdev
added.

-- 
~Randy
