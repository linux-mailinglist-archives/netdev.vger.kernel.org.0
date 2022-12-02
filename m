Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6F86408E0
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 16:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbiLBPAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 10:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233645AbiLBPAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 10:00:10 -0500
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A99D56EC9;
        Fri,  2 Dec 2022 07:00:09 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id DDC02C009; Fri,  2 Dec 2022 16:00:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669993216; bh=eFVoZAfD9YPOPHkY+vtVQeAztonhM8KEg/TJuZEwtyk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZRYxCC+feO+qQnoPKijZmbBfFAQa7Q7NTkHW2QfbIB/shlM0vI2PWs9elzx1U7gkf
         9tc/e3ak1TTY7DIoLiYE7Jnc7Zrpjxj7UQukuff4TLF0bQ+e+H7ooaOitZk8ONb6bT
         RQ8/SzyRepBFQIT90+RxlxDq3w7ZZS6HBf+l8v35TKp8BJYRZlps89P1kfc13rCxxE
         f+zb9ku7FdPnZfdY1EfLwmUgDZWCtDbSlM/rd+Xic83LsBBVQPBCEQIROlGt6N+zgq
         XTydyZmIfOqpXywhXFFS9bXZo9Wj3vN0WFtn8BpvG++ARmlnWjorZq7ENXm5hxBzFN
         CSbZGSFLAnY+A==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 99EDDC009;
        Fri,  2 Dec 2022 16:00:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669993216; bh=eFVoZAfD9YPOPHkY+vtVQeAztonhM8KEg/TJuZEwtyk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZRYxCC+feO+qQnoPKijZmbBfFAQa7Q7NTkHW2QfbIB/shlM0vI2PWs9elzx1U7gkf
         9tc/e3ak1TTY7DIoLiYE7Jnc7Zrpjxj7UQukuff4TLF0bQ+e+H7ooaOitZk8ONb6bT
         RQ8/SzyRepBFQIT90+RxlxDq3w7ZZS6HBf+l8v35TKp8BJYRZlps89P1kfc13rCxxE
         f+zb9ku7FdPnZfdY1EfLwmUgDZWCtDbSlM/rd+Xic83LsBBVQPBCEQIROlGt6N+zgq
         XTydyZmIfOqpXywhXFFS9bXZo9Wj3vN0WFtn8BpvG++ARmlnWjorZq7ENXm5hxBzFN
         CSbZGSFLAnY+A==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 831197e9;
        Fri, 2 Dec 2022 15:00:01 +0000 (UTC)
Date:   Fri, 2 Dec 2022 23:59:46 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH] 9p: Remove unneeded idr.h #include in the net/9p
 directory
Message-ID: <Y4oS4rMkjil1H11K@codewreck.org>
References: <9e386018601d7e4a9e5d7da8fc3e9555ebb25c87.1669560387.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9e386018601d7e4a9e5d7da8fc3e9555ebb25c87.1669560387.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET wrote on Sun, Nov 27, 2022 at 03:46:45PM +0100:
> The 9p net files don't use IDR or IDA functionalities. So there is no point
> in including <linux/idr.h>.
> Remove it.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Thanks, picked this one up as well

-- 
Dominique
