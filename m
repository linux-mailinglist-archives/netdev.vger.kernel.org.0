Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18EE336E3E7
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 06:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238023AbhD2DvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 23:51:12 -0400
Received: from smtp39.i.mail.ru ([94.100.177.99]:35630 "EHLO smtp39.i.mail.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237582AbhD2DvL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 23:51:11 -0400
X-Greylist: delayed 54197 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Apr 2021 23:51:11 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=inbox.ru; s=mail3;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:From:Subject:Content-Type:Content-Transfer-Encoding:To:Cc; bh=DEsFHJksFvVB6BVdQdmnm78vaD4lwpdGojFVXp8+0Xc=;
        b=OCgdmlG/tubEuZNybB7ZNBObUxboUFFumb+25rQVYbBiF/8qL4rjh5ileZ6LhNCO6mnjHqcS+D2pumyj2s4v6qigbC/IF7MWSYvRVLVxqwZQ0sWXFx83O7JWsETnMXyi+XLiQnSf97LCK1Uh+cDxIHpXgBOUWWossJJ9CxOUDQo=;
Received: by smtp39.i.mail.ru with esmtpa (envelope-from <fido_max@inbox.ru>)
        id 1lbxh1-0002jH-4a; Thu, 29 Apr 2021 06:50:23 +0300
Subject: Re: [PATCH 1/1] net: phy: marvell: enable downshift by default
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com
References: <20210428124853.926179-1-fido_max@inbox.ru>
 <YIm38VYp2CKGdppy@lunn.ch>
From:   Maxim Kochetkov <fido_max@inbox.ru>
Message-ID: <bb3efe41-85f5-c57f-1293-0f6fbf610ed6@inbox.ru>
Date:   Thu, 29 Apr 2021 06:52:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <YIm38VYp2CKGdppy@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp39.i.mail.ru; auth=pass smtp.auth=fido_max@inbox.ru smtp.mailfrom=fido_max@inbox.ru
X-7564579A: 646B95376F6C166E
X-77F55803: 4F1203BC0FB41BD9ECFD8CE5F0594010C798B26A9CF6FD3F2B2BC7AAFDCADAFC182A05F538085040BC48D8974E97DB6E6D0A1C62C2F853B901107555B94D22DBFFFFF729B48B67A7
X-7FA49CB5: FF5795518A3D127A4AD6D5ED66289B5278DA827A17800CE728306843C9CFCFEAEA1F7E6F0F101C67BD4B6F7A4D31EC0BCC500DACC3FED6E28638F802B75D45FF8AA50765F790063745D431239A8C7DA08638F802B75D45FF914D58D5BE9E6BC1A93B80C6DEB9DEE97C6FB206A91F05B2AB9C297B352BBEBD65774EEFAE53898142232221D1CC1427D2E47CDBA5A96583C09775C1D3CA48CFA12191B5F2BB8629117882F4460429724CE54428C33FAD30A8DF7F3B2552694AC26CFBAC0749D213D2E47CDBA5A9658378DA827A17800CE73D04F0695778128A9FA2833FD35BB23DF004C90652538430302FCEF25BFAB3454AD6D5ED66289B5278DA827A17800CE7E937145F4808DB80D32BA5DBAC0009BE395957E7521B51C20BC6067A898B09E4090A508E0FED6299176DF2183F8FC7C09F81FD64354FB19DCD04E86FAF290E2D7E9C4E3C761E06A71DD303D21008E29813377AFFFEAFD269A417C69337E82CC2E827F84554CEF50127C277FBC8AE2E8BA83251EDC214901ED5E8D9A59859A8B6A1DCCEB63E2F10FB089D37D7C0E48F6C5571747095F342E88FB05168BE4CE3AF
X-B7AD71C0: AC4F5C86D027EB782CDD5689AFBDA7A2368A440D3B0F6089093C9A16E5BC824A2A04A2ABAA09D25379311020FFC8D4ADDFE48FF8480683258A7C144763EAA5EA
X-C1DE0DAB: 0D63561A33F958A5FEE113A4318AB1ADB6A66F48CDFE156DF64D1EE3112F1AEAD59269BC5F550898D99A6476B3ADF6B47008B74DF8BB9EF7333BD3B22AA88B938A852937E12ACA7579F2895567E1D60F410CA545F18667F91A7EA1CDA0B5A7A0
X-C8649E89: 4E36BF7865823D7055A7F0CF078B5EC49A30900B95165D34F05B761BB9C2AA4431F866ED467B5BE2E5C7ED184E2835E6C123E4BECCE705D2D3C21AF51E596CCF1D7E09C32AA3244C871E1336F0E8B427302C28523586D8FEE3D93501275E802FDCA3B3C10BC03908
X-D57D3AED: 3ZO7eAau8CL7WIMRKs4sN3D3tLDjz0dLbV79QFUyzQ2Ujvy7cMT6pYYqY16iZVKkSc3dCLJ7zSJH7+u4VD18S7Vl4ZUrpaVfd2+vE6kuoey4m4VkSEu530nj6fImhcD4MUrOEAnl0W826KZ9Q+tr5ycPtXkTV4k65bRjmOUUP8cvGozZ33TWg5HZplvhhXbhDGzqmQDTd6OAevLeAnq3Ra9uf7zvY2zzsIhlcp/Y7m53TZgf2aB4JOg4gkr2biojoCaqxM2e5soDvCoSAAJ9aA==
X-Mailru-Sender: 11C2EC085EDE56FA9C10FA2967F5AB24359967F59DDB5060AD2B5FD8491466CEF143A866344D9409EE9242D420CFEBFD3DDE9B364B0DF2891A624F84B2C74EDA4239CF2AF0A6D4F80DA7A0AF5A3A8387
X-Mras: Ok
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

28.04.2021 22:30, Andrew Lunn wrote:
> On Wed, Apr 28, 2021 at 03:48:53PM +0300, Maxim Kochetkov wrote:
>> Enable downshift for all supported PHYs by default like 88E1116R does.
> 
> There are two different mechanisms to set to downshift. And i think
> some of the older PHYs don't support it at all. How did you decide on
> which method to use for each PHY?
> 
>        Andrew
> 

When I said "For all supported PHYs" I mean PHYs whith set_phy_tunable 
defined. So I just added appropriate call of set_downshift found at 
m88*_set_tunable functions to config_init of each PHY with 
set_phy_tunable defined.
