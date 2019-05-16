Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B48BE20D4A
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 18:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbfEPQpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 12:45:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58010 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728490AbfEPQpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 12:45:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D506148FE64A;
        Thu, 16 May 2019 09:45:38 -0700 (PDT)
Date:   Thu, 16 May 2019 09:45:35 -0700 (PDT)
Message-Id: <20190516.094535.44468004372549234.davem@davemloft.net>
To:     herbert@gondor.apana.org.au
Cc:     jakub.kicinski@netronome.com, tgraf@suug.ch,
        netdev@vger.kernel.org, oss-drivers@netronome.com, neilb@suse.com,
        simon.horman@netronome.com
Subject: Re: [PATCH 0/2] rhashtable: Fix sparse warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190516071859.uijycusyfqcs7tc7@gondor.apana.org.au>
References: <20190515205501.17810-1-jakub.kicinski@netronome.com>
        <20190516051622.b4x6hlkuevof4jzr@gondor.apana.org.au>
        <20190516071859.uijycusyfqcs7tc7@gondor.apana.org.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 16 May 2019 09:45:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 16 May 2019 15:18:59 +0800

> This patch series fixes all the sparse warnings.

Series applied, thanks Herbert.
