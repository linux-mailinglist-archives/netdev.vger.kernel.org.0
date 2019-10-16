Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85632D8F6A
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 13:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732754AbfJPL3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 07:29:01 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:42162 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbfJPL3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 07:29:01 -0400
Received: by mail-wr1-f46.google.com with SMTP id n14so27562039wrw.9
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 04:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vpjhoL2u0RfnRvuFSFA1ECNoIWWz2COjhOvHDWFwwEw=;
        b=0YvfllK6EKKAjFwVn/E/tRjJvib7bvJxeYLZahh1KbIUwQkgRjeQcHdzxbiZZcCuHC
         mo5ikUU2o0vImAcmgJQGDbjy2G5m0s9c5RjcV185Y6/fmYIUg6pkHy698OiFTbE99Se3
         oOgBr0NZ4ZN4o2PO86cTuqwhFRYvD6dkLBj8Uiv0pDscZd1vNpD2ctTUHGRRiSTQKkte
         6bABI8MXUEr7ZPGkOz9HwoLvbMVfbByCh533YHTUF+auCOV7kM2ERbGONM5EINC8V3gi
         SCJQn5HWrVtAv5leTd2HGQHJc+jpMv/Ft0xojnXjKC6LCCesczs8mRjulE3O/PIxGNVh
         bK0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vpjhoL2u0RfnRvuFSFA1ECNoIWWz2COjhOvHDWFwwEw=;
        b=kC1nFfKnNsVDeHFongVzeUzArZ2nYhsuuLYrNUosQieZWxD6+uU3EBthZFJXQY6B+O
         ZQ3ADGeEhbVhbG4obTWFLX1flqVA1VrVFJYO1xz5cOEQu66Yk9arzRmR0h+L0slXVH36
         qy48W5ZgQZzf8aBYGFJDSp4+0olz1eczObiT1wk4pjmJe5l24bmDo1j7tku0qCAiqcE0
         lgtpIA72+dRrszb6f9F38pWhp4zs2vRuL+WSNs0dV/i0LuH+fFC26VpT+SFXsScJA4IC
         YXhZHmxruMx8U4s3bIIkekz1+dD5LmGQLT+9Ki9n38nnQ/dHNv3TNOfu2iCEKAVpb4/g
         w1Gw==
X-Gm-Message-State: APjAAAU1xacuylDx5FC4OtWBcmuflp0WL3s0SNWE1Nk+c9DLo/xuDfUG
        Cu5V4d9ZD9mBo7cK+figTlez1g==
X-Google-Smtp-Source: APXvYqzmjLbykFlvinDTzDoYEkPAtipk8SI9k4RupfIwOt4VZCCxrGCNIqIlaa5iEhlTmfDGw1P1Ig==
X-Received: by 2002:a5d:55d0:: with SMTP id i16mr2387231wrw.150.1571225339367;
        Wed, 16 Oct 2019 04:28:59 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id q14sm1070537wre.27.2019.10.16.04.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 04:28:58 -0700 (PDT)
Date:   Wed, 16 Oct 2019 13:28:58 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, stephen@networkplumber.org,
        roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        sd@queasysnail.net, sbrivio@redhat.com, pabeni@redhat.com,
        mlxsw@mellanox.com
Subject: Re: [patch iproute2-next v3 2/2] ip: allow to use alternative names
 as handle
Message-ID: <20191016112858.GA2184@nanopsycho>
References: <20191009124947.27175-1-jiri@resnulli.us>
 <20191009124947.27175-3-jiri@resnulli.us>
 <f0693559-1ba2-ea6c-a36a-ef9146e1ba9b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0693559-1ba2-ea6c-a36a-ef9146e1ba9b@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Oct 15, 2019 at 08:34:56PM CEST, dsahern@gmail.com wrote:
>On 10/9/19 8:49 AM, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>> 
>> Extend ll_name_to_index() to get the index of a netdevice using
>> alternative interface name. Allow alternative long names to pass checks
>> in couple of ip link/addr commands.
>
>you don't add altnames to the name_hash, so the lookup can not find a
>match based on altname.

you are right, it is always going to fall back to ll_link_get(). I will
do another patch to add the altnames to name_hash. It can go in
separatelly or I can add that to this patchset. Up to you.

>
