Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFE83FB9DA
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 18:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237717AbhH3QLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 12:11:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237653AbhH3QLl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Aug 2021 12:11:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE60A60ED8;
        Mon, 30 Aug 2021 16:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630339848;
        bh=t0iof6x9x42q68uvM0OCFCWg9wYixuRiG9pkRM0txqU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TAAWN1M8o2w0XeZ2JYkfmkcRfe1BWXG0w4hc8N6yFNPOY0zGITRbxFiqaQBiTtoKv
         oFywyN1wpUQfKwS6TiAvhqU/WFpYi1PPcqtjOI8sVLJG2i6JbX6LSsPobi54PU0GZc
         ytmqhEXV3vXiTCHd96APcTA3RaDZ2gwj61iDwOI3ZJy7x2xMz+wu7C1rFSYf/C/CY7
         JIoe5G8BszsrFs0DtnJ0aCBxV4L/eUuKcE+C77ik/gdH5ahX+CqRDqQN8DCMc/Jkk7
         Kg1DSTDtpSiCn20VMSkLyy/VsfN2zxuBUqQfkKZDRyM/icUaDZj3AcL57w6XYj3fJa
         a8sSLT5Htfwzw==
Date:   Mon, 30 Aug 2021 09:10:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Haimin Zhang <tcs.kernel@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, vinicius.gomes@intel.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, netdev@vger.kernel.org,
        Haimin Zhang <tcs_kernel@tencent.com>
Subject: Re: [PATCH] net:sched fix array-index-out-of-bounds in
 taprio_change
Message-ID: <20210830091046.610ceb1b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <66e9214c-7c70-eec6-5028-bab137754bd3@gmail.com>
References: <1628658609-1208-1-git-send-email-tcs_kernel@tencent.com>
        <303b095e-3342-9461-16ae-86d0923b7dc7@gmail.com>
        <e965fed3-89c3-ff58-a678-dd715a2b9fcd@gmail.com>
        <66e9214c-7c70-eec6-5028-bab137754bd3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Aug 2021 10:09:38 +0800 Haimin Zhang wrote:
> hi=EF=BC=8Ci wonder to know what=E2=80=98s going on with this patch ?
> are you plannig to merge it ?

Please don't top post. As I told you I think that fix belongs in
taprio_parse_mqprio_opt() which is validating inputs, not in the=20
middle of the code applying the changes.
