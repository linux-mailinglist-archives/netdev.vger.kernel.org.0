Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF6343C3D4
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 09:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238603AbhJ0H1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 03:27:10 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:49113 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231518AbhJ0H1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 03:27:09 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id 9082E580473;
        Wed, 27 Oct 2021 03:24:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 27 Oct 2021 03:24:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zYtwBG
        9RMG2qt6py3aM+lZvt0pX1FIUveB5vk7JEXjk=; b=Q64bMEbgp5lyU6Sc6KuPdn
        Z7l8vPfcBn3z1Zne+eJ1LbVNxAQL8Xo4C9agmINsXFcPlYvOnnaimf0grs06KzdQ
        AgGnxl22YIL5nCwp1DnZqQps6E45VcM+sUdH2+4dh50qVXz1BSciBgflNtkXRyDJ
        9zrAY0+n+gaDgkx2K5agE2HtFHHywaoYbv1NdGCf0b4iQI0zKVvhx0YVWMWaW2iB
        9SZWIdAx05hpF1WLPEOvtkHbN27t46eZb+c2Q5EzRoMY6SNMXkGJkALZOlPsaE8m
        0cvCExiycQncxz58N5/FgkAb1RcEH5jwxli8tVT+NXKxTfWec6auXQPJ44BKexKQ
        ==
X-ME-Sender: <xms:u_54YUMxr6Y4wx7175fn7-duHQLWn47z735OYqPwdAAXXXqEf7aLMw>
    <xme:u_54Ya9HlCrbXz-e6EnafOn18O23_nCiX1in7JcMoL9eTK2YizyBvuO5GOCozUiJt
    8xNH2kUrYKGiD4>
X-ME-Received: <xmr:u_54YbQXPiihOLn3buSYoh5BF1HkHZ_9r77JjG67HUCxhsJ8upijgspCTcn8hzB2PhA3VtW9TJSSb-lHqtNb83SplAnJ7Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefledguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudeh
    leetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:u_54Ycs7jyIe5PkK32K3Xxf33sJy05CfSjF-9Y_kVV0WpWRZnookRA>
    <xmx:u_54YcebHMwID3-xPmDgghtHwDXew3-8JWRe_QSdDFjJ78UFdkcEkw>
    <xmx:u_54YQ26fUqf1PYaVZlrW8kjElCICt4tzKj5RxErO5fOiP-G7soa4A>
    <xmx:vP54YU7l5jmpkhsqqyCvLQ4iNzAeOWSWzqRIoOOLBQAQ3QjdwuOt6g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 03:24:42 -0400 (EDT)
Date:   Wed, 27 Oct 2021 10:24:39 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [RFC PATCH net-next 00/15] Synchronous feedback on FDB add/del
 from switchdev to the bridge
Message-ID: <YXj+txwYHJVsI1sv@shredder>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
 <531e75e8-d5d1-407b-d665-aec2a66bf432@nvidia.com>
 <20211026112525.glv7n2fk27sjqubj@skbuf>
 <1d9c3666-4b29-17e6-1b65-8c64c5eed726@nvidia.com>
 <20211026165424.djjy5xludtcqyqj2@skbuf>
 <a703cf3c-50f5-1183-66a8-8af183737e26@nvidia.com>
 <20211026190136.jkxyqi6b7f4i2bfe@skbuf>
 <dcff6140-9554-5a08-6c23-eeef47dd38d0@nvidia.com>
 <20211026215153.lpdk66rjvsodmxto@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026215153.lpdk66rjvsodmxto@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 09:51:54PM +0000, Vladimir Oltean wrote:
> I'll let Ido answer here. As I said, the model I'm working with is that
> of autonomous learning, so for me, no. Whereas the Spectrum model is
> that of secure learning. I expect that it'd be pretty useless to set up
> software assisted secure learning if you're just going to say yes and
> learn all addresses anyway. I've never seen Spectrum documentation, but
> I would be shocked if it wouldn't be able to be configured to operate in
> the bare-bones autonomous learning mode too.

Hi,

Yes, you are correct. It can support automatic learning, but it was
never enabled. We update the software bridge about learned FDB entries
(unlike DSA I think?), so secure learning makes sense in our case.
