Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE274F60A7
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbiDFNy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234203AbiDFNwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:52:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF30C3D6FFE;
        Tue,  5 Apr 2022 18:26:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A93DB8203A;
        Wed,  6 Apr 2022 01:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626D9C385A0;
        Wed,  6 Apr 2022 01:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649208403;
        bh=yJUkzJ/EKyf8PlyHyI5tKyWRwcgeyxQU+NZ1LoKG+vM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A67hvJf1WQOl0FRiyzVu3IF9JiybuDASSlOmGwGrHouCCOVLRcH6aayruhoje5i76
         EfHq+sOQPLvaQdiYiOLhF4n4yfZmRJsqkxHmvAeQUYjxw4EgnUpMDyao89TYHne/Tz
         VYE6trXKmjyVls0jSKN05hJxqPMaGb5E15TD9dwQ8vQ3SszSD8LW+7C6176x4CtQrI
         VDB1xYSOh616c3ewbzi74UH/po4whOYsW9gDutA97LLAE8aFydFouD24xs0bzH/yoc
         3LCRYZx/uzzivR8bfn0NgMXFey+iSKxEXIhTtySBjvia7sEf4srtlK+NwaGxrr8avs
         4mZi0yfD9P3aQ==
Date:   Tue, 5 Apr 2022 18:26:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] qed: remove an unneed NULL check on list iterator
Message-ID: <20220405182641.08cd18ff@kernel.org>
In-Reply-To: <20220405002256.22772-1-xiam0nd.tong@gmail.com>
References: <20220405002256.22772-1-xiam0nd.tong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 Apr 2022 08:22:56 +0800 Xiaomeng Tong wrote:
>  struct pci_dev *qed_validate_ndev(struct net_device *ndev)
>  {
> -	struct pci_dev *pdev = NULL;
> +	struct pci_dev *pdev;
>  	struct net_device *upper;

Please keep the longest-to-shortest ordering of variable declaration
lines.
