Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E40439FB24
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 09:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfH1HHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 03:07:15 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39367 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfH1HHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 03:07:14 -0400
Received: by mail-wm1-f68.google.com with SMTP id i63so1605481wmg.4
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 00:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=65uAwbp2uXnCk+GD6riGbMRt0XoH3Oc0QdM49ThBYTY=;
        b=2Bwg3opV5ZqhmMKuphmrMxbpIs8gI5tpDAABhmKicMcySz2O0bB7x9ByKRkU0jBUrs
         5f7cWB74mfViG1WimUXBBdgSj7T/FzT7FgwFQMJzgsuC26LEMMeMVEgWIbW9snNQTy9u
         NU/vtM+apsFI/7TMMqZ6yX0CyYN1jvghZz5MON8BtoI7SZcDUCieT7u8Jw1Ic8/oqDxG
         p+dAGaBwg/N91RHECtz5wleteOhHsmEB++tysMKhbFctyvekP9xw0RmyXaSAgi2RGGkx
         n+vg7qcgSOjIFKlu0XWY4q8FPIZDZirZOoA0NaBtrjhQetJ/wSa5jCHlPz9wMjU1xVaN
         g9AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=65uAwbp2uXnCk+GD6riGbMRt0XoH3Oc0QdM49ThBYTY=;
        b=H3CT9UrMepcETP8+gjk2a19L0QG77X9hbfACX1+R3O0X44+lxE7jMLcQzFMudkOiRO
         L6ymIxSFfP8jAQW/Y9C+q5iFvFJrORSaGrrlhE5e4tCQ7NEBEdHiREImcnPDn3gXwDSE
         yrQq/y0HG2rOKTRI6+jXmVMMv77HcEc6EF3R55nYkl+H8BWQgmJ+wfla8BMhceeCFK3R
         dMB3eLd60QcqLKRlVMH4o7atpVSod89AA9UlIjbxhi3gGj8U2gTDDd/w92fqB/ldBmGf
         dvAVaPkA3k6IwzLpjr+ayv5lO+NesQ/fQpYKfv75sXbWNo5/pA9AwSR00a/DitA1MTCI
         6Pcg==
X-Gm-Message-State: APjAAAUzWenUpM1Xy+rMir0hAfuYYryqI5Yp0WDyhoMQrN46Im0wRSWp
        jcKqDQN1/WeWPEkC8J8wiFDItA==
X-Google-Smtp-Source: APXvYqyF0fCMFvLTB7N06Dhrnz4BBOmCG7zPJMKMdQLUP87tDieFiEWiEAPTNNqU4XCkpWPKy10/aQ==
X-Received: by 2002:a05:600c:145:: with SMTP id w5mr2791786wmm.75.1566976032289;
        Wed, 28 Aug 2019 00:07:12 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id l9sm1601962wmi.29.2019.08.28.00.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 00:07:11 -0700 (PDT)
Date:   Wed, 28 Aug 2019 09:07:11 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Ahern <dsahern@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190828070711.GE2312@nanopsycho>
References: <20190826151552.4f1a2ad9@cakuba.netronome.com>
 <20190826.151819.804077961408964282.davem@davemloft.net>
 <20190827070808.GA2250@nanopsycho>
 <20190827.012242.418276717667374306.davem@davemloft.net>
 <20190827093525.GB2250@nanopsycho>
 <CAJieiUjpE+o-=x2hQcsKQJNxB8O7VLHYw2tSnqzTFRuy_vtOxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJieiUjpE+o-=x2hQcsKQJNxB8O7VLHYw2tSnqzTFRuy_vtOxw@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 27, 2019 at 05:14:49PM CEST, roopa@cumulusnetworks.com wrote:
>On Tue, Aug 27, 2019 at 2:35 AM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Tue, Aug 27, 2019 at 10:22:42AM CEST, davem@davemloft.net wrote:
>> >From: Jiri Pirko <jiri@resnulli.us>
>> >Date: Tue, 27 Aug 2019 09:08:08 +0200
>> >
>> >> Okay, so if I understand correctly, on top of separate commands for
>> >> add/del of alternative names, you suggest also get/dump to be separate
>> >> command and don't fill this up in existing newling/getlink command.
>> >
>> >I'm not sure what to do yet.
>> >
>> >David has a point, because the only way these ifnames are useful is
>> >as ways to specify and choose net devices.  So based upon that I'm
>> >slightly learning towards not using separate commands.
>>
>> Well yeah, one can use it to handle existing commands instead of
>> IFLA_NAME.
>>
>> But why does it rule out separate commands? I think it is cleaner than
>> to put everything in poor setlink messages :/ The fact that we would
>> need to add "OP" to the setlink message just feels of. Other similar
>> needs may show up in the future and we may endup in ridiculous messages
>> like:
>>
>> SETLINK
>>   IFLA_NAME eth0
>>   IFLA_ATLNAME_LIST (nest)
>>       IFLA_ALTNAME_OP add
>>       IFLA_ALTNAME somereallylongname
>>       IFLA_ALTNAME_OP del
>>       IFLA_ALTNAME somereallyreallylongname
>>       IFLA_ALTNAME_OP add
>>       IFLA_ALTNAME someotherreallylongname
>>   IFLA_SOMETHING_ELSE_LIST (nest)
>>       IFLA_SOMETHING_ELSE_OP add
>>       ...
>>       IFLA_SOMETHING_ELSE_OP del
>>       ...
>>       IFLA_SOMETHING_ELSE_OP add
>>       ...
>>
>> I don't know what to think about it. Rollbacks are going to be pure hell :/
>
>I don't see a huge problem with the above. We need a way to solve this
>anyways for other list types in the future correct ?.
>The approach taken by this series will not scale if we have to add a
>new msg type and header for every such list attribute in the future.

Do you have some other examples in mind? So far, this was not needed.


>
>A good parallel here is bridge vlan which uses RTM_SETLINK and
>RTM_DELLINK for vlan add and deletes. But it does have an advantage of
>a separate
>msg space under AF_BRIDGE which makes it cleaner. Maybe something
>closer to that  can be made to work (possibly with a msg flag) ?.

1) Not sure if AF_BRIDGE is the right example how to do things
2) See br_vlan_info(). It is not an OP-PER-VLAN. You either add or
delete all passed info, depending on the cmd (RTM_SETLINK/RTM_DETLINK).


>
>Would be good to have a consistent way to update list attributes for
>future needs too.

Okay. Do you suggest to have new set of commands to handle
adding/deleting lists of items? altNames now, others (other nests) later?

Something like:

CMD SETLISTS
     IFLA_NAME eth0
     IFLA_ATLNAME_LIST (nest)
       IFLA_ALTNAME somereallylongname
       IFLA_ALTNAME somereallyreallylongname
       IFLA_ALTNAME someotherreallylongname
     IFLA_SOMETHING_ELSE_LIST (nest)
       IFLA_SOMETHING_ELSE
       IFLA_SOMETHING_ELSE
       IFLA_SOMETHING_ELSE


CMD DELLISTS
     IFLA_NAME eth0
     IFLA_ATLNAME_LIST (nest)
       IFLA_ALTNAME somereallylongname
       IFLA_ALTNAME somereallyreallylongname
       IFLA_ALTNAME someotherreallylongname
     IFLA_SOMETHING_ELSE_LIST (nest)
       IFLA_SOMETHING_ELSE
       IFLA_SOMETHING_ELSE
       IFLA_SOMETHING_ELSE

How does this sound?
