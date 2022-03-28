Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744BA4E9B7A
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 17:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240138AbiC1Prr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 11:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240012AbiC1Pra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 11:47:30 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADEF63516;
        Mon, 28 Mar 2022 08:45:22 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1648482320; bh=K5yQXy54JHY7rUigzUmzvWRAXrXCNGan+s8kLUY9Ypg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ofDZ73PT3hE1qlcu5lkOC7Sq4XZwM2YVi91N9xPgJ8T28zB6ObXxYQLy2Ib9wAkQh
         trPseX/HRnwhCB/Q1iSVmHzDZTK7WAMCRs92J9513k/P+D36geZxbHH9PJBz7zBTs5
         JAjOeESdMBiptiWXnD/0XBUIBlA3VdGERP/vdGzc0CJKCrOlh+542VIEz934paARwx
         EH6uMRV1+3zh9ah3wD1fEVbTTXLSOZR/jQ+DwhDCcVATPXrVWRVNItknc6uWynz40Z
         dHqJem2DBzk1Ogq3y014Ngis6EjOQhHGcwykAzUboE+Bh5qBgXQ5vXwup7Uop5Hun1
         hCfHRA5rzU0Ew==
To:     trix@redhat.com, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: Re: [PATCH v2] ath9k: initialize arrays at compile time
In-Reply-To: <20220328130727.3090827-1-trix@redhat.com>
References: <20220328130727.3090827-1-trix@redhat.com>
Date:   Mon, 28 Mar 2022 17:45:19 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <878rsu5be8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

trix@redhat.com writes:

> From: Tom Rix <trix@redhat.com>
>
> Early clearing of arrays with
> memset(array, 0, size);
> is equivilent to initializing the array in its decl with
> array[size] = {};
>
> Convert the memsets to initializations.
>
> Signed-off-by: Tom Rix <trix@redhat.com>

The changes LGTM. However, the patch doesn't apply cleanly; could you
please rebase against the ath-next branch[0] and resubmit?

-Toke

[0] https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/log/?h=ath-next
