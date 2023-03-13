Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33EC56B84DB
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjCMWjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCMWjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:39:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0F855070;
        Mon, 13 Mar 2023 15:39:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A22E6151F;
        Mon, 13 Mar 2023 22:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D4BC433EF;
        Mon, 13 Mar 2023 22:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678747146;
        bh=FnTfPuCuBIAmqD6wqFmMrPhA+sxnqKPjMi5Tw1nqEbk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ewrxdO3DvTpezen6phVocGEBCoaRam02SiXAgJGWhCfOwloc+MylXnPlR+OnaGLNZ
         psns2oVEcQyNrEoojEVLrAaIxXCAVyIjY68rf6iuumQd/dYELl1fF+Kb4S6IEdcqhg
         DipBloTpBD473zTZXNdFBiWztm6KohZInskBTjRU7jpJcmbzati+Qyy9XfqbCwYJcA
         BhBo2mxkbs6OvmVR94pAKVG1vG8vAYtCIfWs3eJENwydorz6ULL/wFbbve6/qZroeX
         gqsS43rVKp+jprqUDlpoRutOeT8HqrBmHz2Y3rMro0XmWb2CHZzGgwcJU1L3iKCloP
         +PajIeNEU90gQ==
Date:   Mon, 13 Mar 2023 15:39:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zheng Wang <zyytlz.wz@163.com>
Cc:     s.shtylyov@omp.ru, davem@davemloft.net, linyunsheng@huawei.com,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hackerzheng666@gmail.com,
        1395428693sheep@gmail.com, alex000young@gmail.com
Subject: Re: [PATCH net v3] net: ravb: Fix possible UAF bug in ravb_remove
Message-ID: <20230313153904.53647ad7@kernel.org>
In-Reply-To: <20230311180630.4011201-1-zyytlz.wz@163.com>
References: <20230311180630.4011201-1-zyytlz.wz@163.com>
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

On Sun, 12 Mar 2023 02:06:30 +0800 Zheng Wang wrote:
> Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")

You must CC all people involved in a commit if you put it as Fixes.
Are you using the get_maintainer.pl script?
How do you call in exactly?
