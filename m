Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA534221AE2
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 05:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgGPDfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 23:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbgGPDfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 23:35:42 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C03C061755;
        Wed, 15 Jul 2020 20:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=n4smOXtC9oTqOf2bUYG85wWz3ogyObKsOkLewmkalU8=; b=BQECdUMqrizwa2HNrKFjhOiURl
        v++5772g76fkvRsHdmfWw9Dv0c1P8AY7jF2xUMm80oxsaHWH7KiDl23TUEWXmtWTMHMuuDrW7glYt
        Ygsfky+VqGh7bgVrnmg9/h2YCE5clzSM7lMUJY7dBmx2UKEeX9GuNlc6oKeTrmomHmNarBSOWaDdn
        7Z9AUH0MwqibLFqQ/pnqXcOPNutDpv1lA/VylEEOcxXuZMABC7eiXak4LqQ8uZPDW+A8XQKT6r03D
        cBG8Tp6aoVhqJrWcZuwlgbFAAQAGruhenf8TOJNwTKyHS1NyXjlOYew+z+S356he9Af9ko7xWHlnI
        WF2YWSWQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvugL-0008Q6-Cm; Thu, 16 Jul 2020 03:35:37 +0000
Subject: Re: [PATCH 3/9 v2 net-next] net: wimax: fix duplicate words in
 comments
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20200715164246.9054-1-rdunlap@infradead.org>
 <20200715164246.9054-3-rdunlap@infradead.org>
 <20200715203453.4781ddee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <50300854-3b28-3bab-dcf8-4dd49efebf86@infradead.org>
Date:   Wed, 15 Jul 2020 20:35:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200715203453.4781ddee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/20 8:34 PM, Jakub Kicinski wrote:
> On Wed, 15 Jul 2020 09:42:40 -0700 Randy Dunlap wrote:
>>  /*
>> - * CPP sintatic sugar to generate A_B like symbol names when one of
>> - * the arguments is a a preprocessor #define.
>> + * CPP syntatic sugar to generate A_B like symbol names when one of
> 
> synta*c*tic
> 
> Let me fix that up before applying.

eww. Thanks.

>> + * the arguments is a preprocessor #define.
>>   */
> 


-- 
~Randy

