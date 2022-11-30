Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4A563CEB5
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbiK3Fam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232637AbiK3Fai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:30:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909DD69A86;
        Tue, 29 Nov 2022 21:30:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEA91619FF;
        Wed, 30 Nov 2022 05:30:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074CDC433C1;
        Wed, 30 Nov 2022 05:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669786235;
        bh=1TK50U/vtai6Rwr9FlTaVax6I29145N7olGNNgxGURE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gIznxXhG5bBI0tfM4H4oYw/ZyttSK7E2KTeA/3fmxF1URihtoChcX+jgGP3OofRTE
         oJ+fJuTS+7FLYettpHgDwwNrg5GPBmCNA+psMcvkuR0Cy44PkE7pohZ+kQA02QL76p
         1LWamDwAnJCf1zhHqxYFVbpdxGQlbRT6wD+DkaTWfus76tZ733/jz8taLCzaMK7vcy
         nmXulA3/1MU7o0ec6+5c1VzcLP3Dia9Z0dq/86aFsyJWBjHQFXkJQdOUHnfYf4xdt8
         cX19Vul7jwKdua18503oCu8UVltbSU5/Vxjwr7yjgRNn4azmcbcgvQsghVQaf4L/3E
         hAsqOy0QeZh6g==
Date:   Tue, 29 Nov 2022 21:30:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     <netdev@vger.kernel.org>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 net  1/2] vmxnet3: correctly report encapsulated LRO
 packet
Message-ID: <20221129213034.18f7c826@kernel.org>
In-Reply-To: <20221128193205.3820-2-doshir@vmware.com>
References: <20221128193205.3820-1-doshir@vmware.com>
        <20221128193205.3820-2-doshir@vmware.com>
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

On Mon, 28 Nov 2022 11:32:03 -0800 Ronak Doshi wrote:
> +				union Vmxnet3_GenericDesc *gdesc;
> +				

Trailing white space here.
Please use checkpatch.
