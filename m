Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA511C3034
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 00:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgECW4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 18:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726661AbgECW4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 18:56:45 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A7DFC061A0E
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 15:56:45 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x25so6327567wmc.0
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 15:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V5eBgkYMvalGLyDEaybfksMN7EibX13fzIuN2lZT6xc=;
        b=CL/pjsy0vAvGs7SnMtSX3xxuPI2zrRVcBNEeWe+fhayuJiyjJ6jPY9AIiud7K3QXgl
         0vtyS9esA4fP2fwgem+cmOQ7deG2TW2YNDTiL5/kxYlbfkHBCQxQ1vURuyggSfzSkFLv
         x0MKsdxAoVPRBrvKDBdqVdSUPVZxQHuOEhkTPVSrKX8cf9HT43ScOanT4BwxJHMDfW1/
         48QaZ1WaAa6oauSqL11vyzqAK4c7hNR6teZTZjwF2QSnJ8aPoiP5eRG/FtdXSq9mECLA
         02mMKGGZpcmexs8w9locipTA1ezHKM2/2mnq4xjyddLn8HusImFRKJ/jgseB3J5ZvGYk
         rQKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V5eBgkYMvalGLyDEaybfksMN7EibX13fzIuN2lZT6xc=;
        b=f2C+cEVEJk1DwIYUJt2E2C2cR7KFhLnkAQ7Tk1wfbm/mWg7gkOE4VkML1mxdvhSt19
         T73UhrYG2P5pHJ63eHv5GWPSuEt6hhn6kfq2zME+eTDdswISH7AJtruk77gzVAzPvaFG
         7SqSuWqEGxQ+nP/Q090F8M3hz9jjDDihwcose6o71buBWAyhbDnmk3eYr/T+AjOJPUIV
         3r6SbvzjycN1shEl33ChGTJ4e/eHF0nG/jS/N/tB9h5khOeWenWf7bpqlgVVw32vJN/n
         /4gZ86HjK/7gCelehUl4fPgZJaCC132fo4U+Hkma8fDQ/PVLU+82+kGWdcj7aUPN/DIx
         SKpw==
X-Gm-Message-State: AGi0PuYZGPJZR4lXPUbE1RqrijCHNFX1krVejJBPNuNKOoCAuXlw7mFx
        dy8N4yZaTXhCylnjwTTVtobk6dUV
X-Google-Smtp-Source: APiQypIc27+ZwR7G6ljkIo+sJES/uCz+h30TZshxc9uREvo4vz6gobtvWzqLVzMzvk8WgMtKyVLh4g==
X-Received: by 2002:a7b:c181:: with SMTP id y1mr12035351wmi.83.1588546603852;
        Sun, 03 May 2020 15:56:43 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k6sm10891395wma.19.2020.05.03.15.56.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2020 15:56:43 -0700 (PDT)
Subject: Re: [PATCH net-next 1/6] net: dsa: export dsa_slave_dev_check and
 dsa_slave_to_port
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Po Liu <po.liu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang@nxp.com>,
        Mingkai Hu <mingkai.hu@nxp.com>,
        Christian Herber <christian.herber@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        vlad@buslov.dev, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200503211035.19363-1-olteanv@gmail.com>
 <20200503211035.19363-2-olteanv@gmail.com>
 <71b974ca-66b4-b697-28fc-106cad586fba@gmail.com>
 <CA+h21hono93B+GQ7xi07_K7TMf2teP=62tu4cBigs--X5gQMLA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <04606444-900f-53d3-4206-5f26cc9bb42d@gmail.com>
Date:   Sun, 3 May 2020 15:56:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hono93B+GQ7xi07_K7TMf2teP=62tu4cBigs--X5gQMLA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/3/2020 3:47 PM, Vladimir Oltean wrote:
> Hi Florian,
> 
> On Mon, 4 May 2020 at 01:45, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>>
>>
>> On 5/3/2020 2:10 PM, Vladimir Oltean wrote:
>>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>>>
>>> To be able to perform mirroring and redirection through tc-flower
>>> offloads (the implementation of which is given raw access to the
>>> flow_cls_offload structure), switch drivers need to be able to call
>>> these functions on act->dev.
>>>
>>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>> ---
>>> Changes from RFC:
>>> None.
>>>
>>>  include/net/dsa.h  | 2 ++
>>>  net/dsa/dsa_priv.h | 8 --------
>>>  net/dsa/slave.c    | 9 +++++++++
>>>  3 files changed, 11 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/include/net/dsa.h b/include/net/dsa.h
>>> index fb3f9222f2a1..62beaa4c234e 100644
>>> --- a/include/net/dsa.h
>>> +++ b/include/net/dsa.h
>>> @@ -739,6 +739,8 @@ int dsa_port_get_phy_strings(struct dsa_port *dp, uint8_t *data);
>>>  int dsa_port_get_ethtool_phy_stats(struct dsa_port *dp, uint64_t *data);
>>>  int dsa_port_get_phy_sset_count(struct dsa_port *dp);
>>>  void dsa_port_phylink_mac_change(struct dsa_switch *ds, int port, bool up);
>>> +bool dsa_slave_dev_check(const struct net_device *dev);
>>> +struct dsa_port *dsa_slave_to_port(const struct net_device *dev);
>>>
>>>  struct dsa_tag_driver {
>>>       const struct dsa_device_ops *ops;
>>> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
>>> index 6d9a1ef65fa0..32bf570fd71c 100644
>>> --- a/net/dsa/dsa_priv.h
>>> +++ b/net/dsa/dsa_priv.h
>>> @@ -173,19 +173,11 @@ extern const struct dsa_device_ops notag_netdev_ops;
>>>  void dsa_slave_mii_bus_init(struct dsa_switch *ds);
>>>  int dsa_slave_create(struct dsa_port *dp);
>>>  void dsa_slave_destroy(struct net_device *slave_dev);
>>> -bool dsa_slave_dev_check(const struct net_device *dev);
>>>  int dsa_slave_suspend(struct net_device *slave_dev);
>>>  int dsa_slave_resume(struct net_device *slave_dev);
>>>  int dsa_slave_register_notifier(void);
>>>  void dsa_slave_unregister_notifier(void);
>>>
>>> -static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
>>> -{
>>> -     struct dsa_slave_priv *p = netdev_priv(dev);
>>> -
>>> -     return p->dp;
>>> -}
>>> -
>>>  static inline struct net_device *
>>>  dsa_slave_to_master(const struct net_device *dev)
>>>  {
>>> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
>>> index ba8bf90dc0cc..4eeb5b47ef99 100644
>>> --- a/net/dsa/slave.c
>>> +++ b/net/dsa/slave.c
>>> @@ -62,6 +62,14 @@ static int dsa_slave_get_iflink(const struct net_device *dev)
>>>       return dsa_slave_to_master(dev)->ifindex;
>>>  }
>>>
>>> +struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
>>> +{
>>> +     struct dsa_slave_priv *p = netdev_priv(dev);
>>> +
>>> +     return p->dp;
>>> +}
>>> +EXPORT_SYMBOL_GPL(dsa_slave_to_port);
>>
>> You could probably make this a static inline in net/dsa.h, too. With or
>> without doing that:
> 
> With dereferencing dsa_slave_priv, I don't think so.

Yes, I missed that dsa_slave_priv is not visible outside of dsa_priv.h
(on purpose). Thanks!
-- 
Florian
