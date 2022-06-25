Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E76E55A755
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 07:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiFYFkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 01:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiFYFkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 01:40:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DB150B04
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 22:40:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BD49B82234
        for <netdev@vger.kernel.org>; Sat, 25 Jun 2022 05:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D81C3411C;
        Sat, 25 Jun 2022 05:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656135600;
        bh=j5NDeeSlCsjvsc6dDiBFwttAi1jBRrwaVwUHuYdjiiE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wqydzxl84/oSi5MuBcnNyTPHbxkPFQqI0bEO5HohogpCWzL1gAiB/3m+nT/XU6edT
         ZrzQ5feSh4QBIIDlfHs6VDF9v3cmcVbmd1GSl9PbF5SMx/Q948xqulSXUbMj/pMhrC
         YH2TskLg59q9q+EPjFZSruhdOCBD/Z+69D96d3bTFxl4qGiaohbhSMKWYt4rC2VR7w
         T2I+vVkgg3LiAX+7vfItYco3NUfRcNMRj4u2yZhYsE7POqff7p4Qn4kJBj1X71jolY
         icY0u0RCIYqRgmd/4yMjDUxgkUmYUeRs21bE6bR0SpZJSp50vvbX564wj/BxoNDdrt
         4/56Y2o+fmodA==
Date:   Fri, 24 Jun 2022 22:39:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     James Yonan <james@openvpn.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: nf_nat_initialized() doesn't modify
 struct nf_conn, so pointer should be declared const
Message-ID: <20220624223945.0c2a9470@kernel.org>
In-Reply-To: <20220624164552.3813986-1-james@openvpn.net>
References: <20220624164552.3813986-1-james@openvpn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Jun 2022 10:45:52 -0600 James Yonan wrote:
> This is helpful for code readability and makes it possible
> to call nf_nat_initialized() with a const struct nf_conn *.

If you want this change to have any chance of getting into mainline you
need to CC maintainers. 
