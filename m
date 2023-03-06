Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0566ACC63
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 19:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbjCFSXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 13:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbjCFSXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 13:23:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2089064211;
        Mon,  6 Mar 2023 10:22:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B128060FFA;
        Mon,  6 Mar 2023 18:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F976C4339B;
        Mon,  6 Mar 2023 18:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678126912;
        bh=9sp+c2BKIPMkS+xj8CKMF4eEJ/I4oa4VNqTO3JC6YQQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DxC8jIDKQKdkzFADrYZpg4I2OSF5bu+8lCNK55tIQcRiiWcyzFUz4xz+HlHJxq9oq
         Ec9OJKWjAdt+vRkEtaorjuHgxKM+zWoR6CFAPiyzt+vEQUDpThianN8CidD+fM9WvQ
         wAa3hrbCwFoHMqy+FNO7gUJKlz1sYM6jzIQQWev05+8/FybcBAB+4D1/cBnWJHcvfN
         R72fyYoaoscKSvVQ5GKp4/uMRyazNeqzwSpyBgGCjO7jl7496tLEiaKRKg3qn/4Tyi
         I55jZxiVtkEKqQH+5YI0P0ybeRBeoFENqadwGcHp5hTwIxpMRo6SU/PHv5BSB+/U6W
         89fhU8qPN+Hcw==
Date:   Mon, 6 Mar 2023 10:21:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, hawk@kernel.org,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        lorenzo.bianconi@redhat.com
Subject: Re: [RFC net-next] ethtool: provide XDP information with
 XDP_FEATURES_GET
Message-ID: <20230306102150.5fee8042@kernel.org>
In-Reply-To: <ced8d727138d487332e32739b392ec7554e7a241.1678098067.git.lorenzo@kernel.org>
References: <ced8d727138d487332e32739b392ec7554e7a241.1678098067.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  6 Mar 2023 11:26:10 +0100 Lorenzo Bianconi wrote:
> Implement XDP_FEATURES_GET request to get network device information
> about supported xdp functionalities through ethtool.

You need to explain why. This is duplicating uAPI.
