Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D72B3610AB
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 19:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233906AbhDORC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 13:02:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232642AbhDORC6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 13:02:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF29D6117A;
        Thu, 15 Apr 2021 17:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618506155;
        bh=7IIWnysI3KMeolE4TRMOAPPv3Ar54wa/csvA/FbGESo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QTtXNeajkIOu2dUZ+fNb8BoASLXQlbajdGap0B+3cMoHzy53bLcK3gAFrFlrV2xIW
         DdLwSavW8u1gTuqP2Y6vsMT+F2eE79d8ieLyjZHrWUe5UdAeZbMq6PuF0el47q7iOW
         c2lctMtMZQmdAxe6davO4aeIL31hVwf+KmNw+hkMJsYIhjWHfnzurqXEkzkb7jy3gJ
         dxY09/wzEyI3w7qdWzJ3PHLfABhXtgQVH77MyKeTGWOLzQMb6lQuYM7lJhp6stL0G7
         VIeWWx5QhQhrEjNd0VxEaMBX2zWLx7aOOkFVXpeIj8FL4pgl0Pm+/4gN/YQn3OYfv+
         wlXTrxwGgh65w==
Date:   Thu, 15 Apr 2021 10:02:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     jin yiting <jinyiting@huawei.com>
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <security@kernel.org>, <linux-kernel@vger.kernel.org>,
        Xuhanbing <xuhanbing@huawei.com>,
        "wangxiaogang (F)" <wangxiaogang3@huawei.com>
Subject: Re: bonding: 3ad: update slave arr after initialize
Message-ID: <20210415100234.0531ae82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0647a502-f54c-30ad-5b5f-c94948f092c8@huawei.com>
References: <0647a502-f54c-30ad-5b5f-c94948f092c8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Apr 2021 14:59:49 +0800 jin yiting wrote:
>  From 71e63af579edd15ad7f7395760a19f67d9a1d7d3 Mon Sep 17 00:00:00 2001
> From: jin yiting <jinyiting@huawei.com>
> Date: Wed, 31 Mar 2021 20:38:40 +0800
> Subject: [PATCH] bonding: 3ad: update slave arr after initialize
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit

Please try git-send-email, the patch was malformed by Thunderbird.
