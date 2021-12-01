Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA0AF4647DE
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 08:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241200AbhLAH0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 02:26:14 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:39764 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbhLAH0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 02:26:13 -0500
Received: from smtpclient.apple (p5b3d2e91.dip0.t-ipconnect.de [91.61.46.145])
        by mail.holtmann.org (Postfix) with ESMTPSA id CAF0FCECDD;
        Wed,  1 Dec 2021 08:22:51 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.20.0.1.32\))
Subject: Re: [PATCH 01/15] skbuff: introduce skb_pull_data
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211130182742.7537e212@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Wed, 1 Dec 2021 08:22:51 +0100
Cc:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Content-Transfer-Encoding: 7bit
Message-Id: <BD3EDAD7-9B40-4F75-B5E6-E90887D48F95@holtmann.org>
References: <20211201000215.1134831-1-luiz.dentz@gmail.com>
 <20211201000215.1134831-2-luiz.dentz@gmail.com>
 <20211130171105.64d6cf36@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CABBYNZJGpswn03StZb97XQOUu5rj2_GGkj-UdZWdQOwuWwNVXQ@mail.gmail.com>
 <20211130182742.7537e212@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
To:     Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3693.20.0.1.32)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

>>> It doesn't take a data pointer, so not really analogous to
>>> skb_put_data() and friends which come to mind. But I have
>>> no better naming suggestions. You will need to respin, tho,
>>> if you want us to apply these directly, the patches as posted
>>> don't apply to either netdev tree.  
>> 
>> I cross posted it to net-dev just in case you guys had some strong
>> opinions on introducing such a function,
> 
> Someone else still may, I don't :)
> 
>> it was in fact suggested by Dan but I also didn't find a better name
>> so I went with it, if you guys prefer we can merge it in
>> bluetooth-next first as usual.
> 
> Going via bluetooth-next sounds good!

if you are ok with this going via bluetooth-next, then I need some sort
of ACK from you or Dave.

Regards

Marcel

