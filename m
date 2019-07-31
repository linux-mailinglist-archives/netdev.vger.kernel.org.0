Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 623637CD17
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 21:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728997AbfGaTqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 15:46:16 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:37314 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbfGaTqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 15:46:16 -0400
Received: by mail-pl1-f171.google.com with SMTP id b3so30962352plr.4
        for <netdev@vger.kernel.org>; Wed, 31 Jul 2019 12:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v5cRzxm5BGN5LFJgrtrrZlTviT2Cg3gqyrnNUlFBXZY=;
        b=lT1cTSapQepLKQm4wfXlz9s2ul0YgghAYKd8mU2Yq5hM+8iGdWBnzjZ/Yjc6zR3Iy1
         eO9owcUjHsxX0uE0HX0OLIzW0McYmFgax7BgPxUYnMB+0ihqLvwSNEr1hOtwqWdUQpgU
         v6wONGhcSg5jpa850z9Y64XmL1TJSDVWHykFsKUu9z6nexKbeyrtDEuHCY5+0yR2Z8ur
         a9QuRt7qV1Mqt+U/A/sCUP1HjbzYiePDyD4CrPIG3Dm2c/JMNPp1gWBL4Vb2youle5Hq
         EwXPIIdNqH120mAbbgpZHMzsdEUaMEzzBY3myBVyAie3vwbKxtMXv1fc6n1ZWCI1Rbjm
         yvwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v5cRzxm5BGN5LFJgrtrrZlTviT2Cg3gqyrnNUlFBXZY=;
        b=sEdi2N6uMt0tyllncyXo3L2hwGjA54ZaGGIC92IvHrHsW5xTuklGKrKYq9H/Yv0Xfj
         gwXmgSFKa31x6PPEjjKyHtKVjW8EElToVZ0j4x7TtvuhagnSODn/pS7QfkWFhkhvbU0e
         LSSVoAkP5UKN5JsoTEtUqkFcGOngCxpMoyY2xd4wsF2ieyra4CO2mDPBhcQ88pjZtTbE
         kTaQeey2IdJ4Fk0BeP/q7AsawHUO16WNBpx5Bi6oTIt1aUtWWKto4W7aRw1fkmvw7MYM
         GIjSPyDAojzS1GleXmzWvui3J8cMorDVv0gM5S4iZfZseM59l13EMyNkc7nfSgKKlOpr
         Bf9w==
X-Gm-Message-State: APjAAAUsUTCj2MopBjdVT0t0GxBpHOt5abozzv8/On9LKFFXE3OmZzEV
        V39TkrCNLY8TMZUymQ0PkcI=
X-Google-Smtp-Source: APXvYqwvfxrAgnmEEp1G0L7TidICX5RRYneLELNQuICWJyPIzANrVKcYi/G0AcIV1ndFpVHy6Pu6kg==
X-Received: by 2002:a17:902:7488:: with SMTP id h8mr47990671pll.168.1564602375400;
        Wed, 31 Jul 2019 12:46:15 -0700 (PDT)
Received: from [172.27.227.172] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id h13sm35997545pfn.13.2019.07.31.12.46.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 12:46:14 -0700 (PDT)
Subject: Re: [patch net-next v2 1/3] net: devlink: allow to change namespaces
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        sthemmin@microsoft.com, mlxsw@mellanox.com
References: <20190730085734.31504-1-jiri@resnulli.us>
 <20190730085734.31504-2-jiri@resnulli.us>
 <20190730153952.73de7f00@cakuba.netronome.com>
 <20190731192627.GB2324@nanopsycho>
 <c4f83be2-adee-1595-f241-de4c26ea55ca@gmail.com>
 <20190731194502.GC2324@nanopsycho>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <087f584d-06c5-f4b9-722b-ccb72ce0e5de@gmail.com>
Date:   Wed, 31 Jul 2019 13:46:13 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190731194502.GC2324@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/31/19 1:45 PM, Jiri Pirko wrote:
>> check. e.g., what happens if a resource controller has been configured
>> for the devlink instance and it is moved to a namespace whose existing
>> config exceeds those limits?
> 
> It's moved with all the values. The whole instance is moved.
> 

The values are moved, but the FIB in a namespace could already contain
more routes than the devlink instance allows.

