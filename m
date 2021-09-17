Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C312740EEE4
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 03:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242471AbhIQBqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 21:46:48 -0400
Received: from mail-il1-f173.google.com ([209.85.166.173]:43626 "EHLO
        mail-il1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242460AbhIQBqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 21:46:47 -0400
Received: by mail-il1-f173.google.com with SMTP id b15so8598939ils.10;
        Thu, 16 Sep 2021 18:45:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SRwnAr4ILMQTscVFm9dj+WlM5ulz8L4gSSBzHDyH6hE=;
        b=DhcF+WU5M/a4U5+noRdjbE8YGN7Gw0QKcgEr6XvZTActDAfFMoVn/VwaDqsGv1R91g
         xKgvu8H2OUE/FrFn0abXVfT1uWmU4HBM3Fn63tr8PNORmeiLvs96eNx37XslnO9XxEA8
         OUyeBgnU6FDVVdkI2QJFr6/SCBXsouX9O54BiMZxgPptg2yYbJBssdrJcqAtZpUGkgfy
         wBBhYGK3JrxE/FQ5PNS2fWlRO1btI6t5fQIbM3gppgViOj3IVB87Z0nsl3+ZT2CvdGP7
         FuLz4nwP2eLXuMHIs/v0guT1Ghu8eTskn4csmZsnCgdgTkaO9RNppSOT7Nzer0FGMAUm
         uIaw==
X-Gm-Message-State: AOAM533JvA9NZgFe9e5Sjv6/3dXKmw3ljNgp+Fcdca1aLUa/4HM6OFkc
        /2AFOcT9Wh8N8HX+UchVEXJVlX6HKQ==
X-Google-Smtp-Source: ABdhPJygin3qGV4r7vzWed2wcAhcroO7KQK88VkWP7w98SvJDjdIdKMV6DCIcvC+RzUU1axIysnQKQ==
X-Received: by 2002:a05:6e02:156c:: with SMTP id k12mr6095416ilu.61.1631843126429;
        Thu, 16 Sep 2021 18:45:26 -0700 (PDT)
Received: from robh.at.kernel.org (96-84-70-89-static.hfc.comcastbusiness.net. [96.84.70.89])
        by smtp.gmail.com with ESMTPSA id s7sm2543558ioe.11.2021.09.16.18.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 18:45:25 -0700 (PDT)
Received: (nullmailer pid 1588176 invoked by uid 1000);
        Fri, 17 Sep 2021 01:45:24 -0000
Date:   Thu, 16 Sep 2021 20:45:24 -0500
From:   Rob Herring <robh@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 02/23] dt-bindings: net: dsa: sja1105: update
 nxp,sja1105.yaml reference
Message-ID: <YUPzNF0rPhjlQKDU@robh.at.kernel.org>
References: <cover.1631785820.git.mchehab+huawei@kernel.org>
 <994ce6c6358746ff600459822b9f6e336db933c9.1631785820.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <994ce6c6358746ff600459822b9f6e336db933c9.1631785820.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Sep 2021 11:55:01 +0200, Mauro Carvalho Chehab wrote:
> Changeset 62568bdbe6f6 ("dt-bindings: net: dsa: sja1105: convert to YAML schema")
> renamed: Documentation/devicetree/bindings/net/dsa/sja1105.txt
> to: Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml.
> 
> Update its cross-reference accordingly.
> 
> Fixes: 62568bdbe6f6 ("dt-bindings: net: dsa: sja1105: convert to YAML schema")
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/networking/dsa/sja1105.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Applied, thanks!
