Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B6B348772
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 04:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhCYDTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 23:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbhCYDTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 23:19:24 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74309C06174A
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 20:19:19 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id g8-20020a9d6c480000b02901b65ca2432cso652221otq.3
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 20:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=asJPfZGZuXYi9X08wooCn6deMyGvHStRhqXU6P4cWJc=;
        b=p9LTOyl53rXAbFXKbkh1ipw7euFQcR5ONFQgrMIqROv0PBXHXfz4pn/OHr0MoqqeOr
         jI8EkBsu9dwAg9AyD01t2BD64tsBMqUPwEVEl0RKPFf7RIJ2h3xUr1btvlzFM3yBBjJ3
         aGZISRWWNU+IVbpkQ8znJgXpzhcwgz6RSvkDjW/h+KKCSLlOLrQZalIQvdRMQ5cz2RDq
         NbmWCaWedaFc33wLxN1LnhqkOUzTQ2L9dcCwtaC3F/DibYB7jc66HM28VQ1scFlVW9Qk
         nw2QqW8Mjgm8FYBBhYk7pUXSWBhE1s+cU0oi80kN8j12YiOz5NLbLRBJNqSnr0tPYKKI
         cj2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=asJPfZGZuXYi9X08wooCn6deMyGvHStRhqXU6P4cWJc=;
        b=B34r4tvfr1MO/T+G0/Bw8EkkU5isvE0X0eC+p8iSDN9Nt0sUvqYLYm88y7FXbH/T7R
         O9rGy9X/M1ZrCBoNBERFhjPHoR2oZy2QTGM+4Jzc4CiKbwAuEuHGAgBMMGSH1I/ZEDry
         2BSLwT23taIbKd1Ajx0RREHnhUL2Ske8lIaJu14krA/VGGCiUz79YUc1M1HJl3b11eld
         GmD0dxH5xTJmjPdo6VeFZq6GyvoLBDyzivCGLKFfjZcNe8F3QlLbVVpa2I3/RaSlXn6I
         u26AglI0uJ+/TjVThB0X6Iog2wd1UcQArBGb5CPnOo5wQRBEQCPrE40mtkLkrSFS5/sr
         Drpw==
X-Gm-Message-State: AOAM531DqEG36qAHmX2lE5stKz9Khl2hXTgANRqLUJBg9018R8mf8lEh
        u1oRiW8zVIkA5fsgOFK53Qow6rOUKcM=
X-Google-Smtp-Source: ABdhPJz/EXJl54hw8Ekn1KYWA0SIqiZu+C4XieeQS+pujsqaXl980UXybkA+XcWEattBGvE6p9b2mA==
X-Received: by 2002:a05:6830:1e51:: with SMTP id e17mr5686764otj.292.1616642358708;
        Wed, 24 Mar 2021 20:19:18 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id z6sm1082940otq.48.2021.03.24.20.19.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 20:19:18 -0700 (PDT)
Subject: Re: rfc5837 and rfc8335
To:     Ron Bonica <rbonica@juniper.net>, Zachary Dodds <zdodds@gmail.com>,
        Ishaan Gandhi <ishaangandhi@gmail.com>
Cc:     Andreas Roeseler <andreas.a.roeseler@gmail.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "junipeross20@cs.hmc.edu" <junipeross20@cs.hmc.edu>
References: <20210317221959.4410-1-ishaangandhi@gmail.com>
 <f65cb281-c6d5-d1c9-a90d-3281cdb75620@gmail.com>
 <5E97397E-7028-46E8-BC0D-44A3E30C41A4@gmail.com>
 <45eff141-30fb-e8af-5ca5-034a86398ac9@gmail.com>
 <CA+FuTSd9kEnU3wysOVE21xQeC_M3c7Rm80Y72Ep8kvHaoyox+w@mail.gmail.com>
 <6a7f33a5-13ca-e009-24ac-fde59fb1c080@gmail.com>
 <a41352e8-6845-1031-98ab-6a8c62e44884@gmail.com>
 <5A3D866B-F2BF-4E30-9C2E-4C8A2CFABDF2@gmail.com>
 <CAJByZJBNMqVDXjcOGCJHGcAv+sT4oEv1FD608TpA_e-J2a3L2w@mail.gmail.com>
 <BL0PR05MB5316A2F5C2F1A727FA0190F3AE649@BL0PR05MB5316.namprd05.prod.outlook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <994ee235-2b1f-bec8-6f3d-bb73c1a76c3a@gmail.com>
Date:   Wed, 24 Mar 2021 21:19:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <BL0PR05MB5316A2F5C2F1A727FA0190F3AE649@BL0PR05MB5316.namprd05.prod.outlook.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/21 10:39 AM, Ron Bonica wrote:
> Hi Folks,
> 
>  
> 
> The rationale for RFC 8335 can be found in Section 5.0 of that document.
> Currently, ICMP ECHO and ECHO RESPONSE messages can be used to determine
> the liveness of some interfaces. However, they cannot determine the
> liveness of:
> 
>  
> 
>   * An unnumbered IPv4 interface
>   * An IPv6 interface that has only a link-local address
> 
>  
> 
> A router can have hundreds, or even thousands of interfaces that fall
> into these categories.
> 
>  
> 
> The rational for RFC 5837 can be found in the Introduction to that
> document. When a node sends an ICMP TTL Expired message, the node
> reports that a packet has expired on it. However, the source address of
> the ICMP TTL Expired message doesn’t necessarily identify the interface
> upon which the packet arrived. So, TRACEROUTE can be relied upon to
> identify the nodes that a packet traverses along its delivery path. But
> it cannot be relied upon to identify the interfaces that a packet
> traversed along its deliver path.
> 
>  

It's not a question of the rationale; the question is why add this
support to Linux now? RFC 5837 is 11 years old. Why has no one cared to
add support before now? What tooling supports it? What other NOS'es
support it to really make the feature meaningful? e.g., Do you know what
Juniper products support RFC 5837 today?

More than likely Linux is the end node of the traceroute chain, not the
transit or path nodes. With Linux, the ingress interface can lost in the
layers (NIC port, vlan, bond, bridge, vrf, macvlan), and to properly
support either you need to return information about the right one.
Unnumbered interfaces can make that more of a challenge.
