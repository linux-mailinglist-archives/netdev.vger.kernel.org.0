Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1CEC432F2E
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 09:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234384AbhJSHU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 03:20:59 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:44552 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbhJSHU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 03:20:59 -0400
Received: from [IPv6:2003:e9:d74b:bb71:f660:f6a1:9bf9:60bf] (p200300e9d74bbb71f660f6a19bf960bf.dip0.t-ipconnect.de [IPv6:2003:e9:d74b:bb71:f660:f6a1:9bf9:60bf])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 4A7DAC050A;
        Tue, 19 Oct 2021 09:18:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1634627922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=py9gkOp2xo053DN39ARED1V0IJZyIE4Yq2gOUzuNvas=;
        b=Q4FIZJzFpjp2+tZvPEa0+jXnQ5UJEY0Um8MeF8Cb7+nZ6azi2qo1BZ/hmIT7kJRLMhuKq6
        FhoQijjAv6kAgdf8HTmb0b6ctfO4Od82tPumF8hlcybsnbGToiUqAJpUXyopTiZyhTs70I
        3dYgqZoCrVVEiOr3gqaOi3TboGHpIwzUJ+bZSZM3beGKx0XFfoY5CK7gU82bhcScZrSS5N
        u1Vnwu/O1iefLxb4iCyUZoWhkCTvpLrFo+6/CvLg0xSH4F1Pb3/ODrEoCg+qCr2+xtPOu/
        06URfzq+z3/3jgoQqoaPq+WcxhGI4o5SZGirXDVqjoUxsRXxSgooyEFcG9vqUA==
Subject: Re: [PATCH] ieee802154: Remove redundant 'flush_workqueue()' calls
To:     Jakub Kicinski <kuba@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     h.morris@cascoda.com, alex.aring@gmail.com, davem@davemloft.net,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <fedb57c4f6d4373e0d6888d13ad2de3a1d315d81.1634235880.git.christophe.jaillet@wanadoo.fr>
 <0a080522-a30b-8b78-86d2-66c1c1a5f604@datenfreihafen.org>
 <20211018141452.544931a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <9d1d9607-ffc8-1a01-075c-dccc54eb0373@datenfreihafen.org>
Date:   Tue, 19 Oct 2021 09:18:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211018141452.544931a7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub.

On 18.10.21 23:14, Jakub Kicinski wrote:
> On Sat, 16 Oct 2021 22:54:52 +0200 Stefan Schmidt wrote:
>> I have nothing else in my ieee802154 tree for net right now so it would
>> be great if you could take it directly.
> 
> Do you mean net or net-next? This looks like net-next material.

Yes, net-next, please.

> Just to be sure, applying directly is not a problem.
> 

Thanks.

regards
Stefan Schmidt

