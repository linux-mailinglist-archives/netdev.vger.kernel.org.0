Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C65C9129C
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 21:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfHQTEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 15:04:35 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36193 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfHQTEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 15:04:35 -0400
Received: by mail-wm1-f65.google.com with SMTP id g67so6671586wme.1;
        Sat, 17 Aug 2019 12:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tFiDWwazQ1dXavuw/9Ov0wuQnU4q+4t68huQcXB9kWs=;
        b=DjHQhDXQoOEXJ9ZLXXKdKZc0uJPYDqNOzzwcDC0cnZaNTJnn8VfUzmPYIsyOXyMG4e
         d3Xzc6VRtgd+QAu/C9Rnuums6QkRGTBJQKFx9/AH0pWl2fIEexh1V7kUTwcqAO/gRcI+
         zmYSYCtBV61SLl6AvbDo4bAbpEInyJB3NvOQOcccRbiXyQUdNphyOZT3yCgfOSQKZU7z
         1afrlaKkSUqvU68sxG0NsQo31/c9ZXSEjFmVttMok5XH7bMXiir9kXde+syaTIkeLQpY
         Su2RbyRS2YWhzzJXgHs/u0+K/mugK7lEt6R6DIFaxcPbSDIrleh+jv88T7uINjHtuV/Q
         7y/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tFiDWwazQ1dXavuw/9Ov0wuQnU4q+4t68huQcXB9kWs=;
        b=uUxrV1rHKDrKkJAt7OcqGxGUTldekj3uaEwQ1/ijlKXOnDQRubuxfxEwpWgFja1DlZ
         kp1k3gI9APuT45EEk+A6yCUhJ7iKC737hCu2lKXop7wefhp8oGkXEK7wYZYUKSLNeuNL
         AyboFpxNROM0kfyjFM1v+NAo9z4fNUTO1r4r7YjT7wjW3CyZd/gD/zorQI8UudSNnDCx
         FzzSmdJArCxPCVJN5uRlNwOWBREfcTcpOdNeHuhuIloYogOlfUhD0rLTstdtSXPe6JC4
         L90XP5YN7gBhxnmABbi6xnZIeBcBbewX7e+Fq7MxH4rCs97DgRzgk80EnMIjX4X7Hn7K
         p9Aw==
X-Gm-Message-State: APjAAAWHXl5qIDIsZTimsUIpCBGkjMy8LcuU4a/lY8RmGxjybNRmv7CP
        f5Um0MCCC77uRaVCy8nh7h6/I40chCjDpR7ap4wwCw==
X-Google-Smtp-Source: APXvYqy+8NueQct7R9G9vAVSVxtmInOccfN5frTOu2PTFvjjMDNnr/PTL7hTY3/eUeZgvWKNTFk7TvV1Ho9yMpT8gw0=
X-Received: by 2002:a05:600c:2056:: with SMTP id p22mr12265337wmg.155.1566068672740;
 Sat, 17 Aug 2019 12:04:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAA5aLPhf1=wzQG0BAonhR3td-RhEmXaczug8n4hzXCzreb+52g@mail.gmail.com>
 <CAM_iQpVyEtOGd5LbyGcSNKCn5XzT8+Ouup26fvE1yp7T5aLSjg@mail.gmail.com>
 <CAA5aLPiqyhnWjY7A3xsaNJ71sDOf=Rqej8d+7=_PyJPmV9uApA@mail.gmail.com> <CAM_iQpUH6y8oEct3FXUhqNekQ3sn3N7LoSR0chJXAPYUzvWbxA@mail.gmail.com>
In-Reply-To: <CAM_iQpUH6y8oEct3FXUhqNekQ3sn3N7LoSR0chJXAPYUzvWbxA@mail.gmail.com>
From:   Akshat Kakkar <akshat.1984@gmail.com>
Date:   Sun, 18 Aug 2019 00:34:33 +0530
Message-ID: <CAA5aLPjzX+9YFRGgCgceHjkU0=e6x8YMENfp_cC9fjfHYK3e+A@mail.gmail.com>
Subject: Re: Unable to create htb tc classes more than 64K
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        lartc <lartc@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 17, 2019 at 11:54 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Sat, Aug 17, 2019 at 5:46 AM Akshat Kakkar <akshat.1984@gmail.com> wrote:
> >
> > I agree that it is because of 16bit of minor I'd of class which
> > restricts it to 64K.
> > Point is, can we use multilevel qdisc and classes to extend it to more
> > no. of classes i.e. to more than 64K classes
>
> If your goal is merely having as many classes as you can, then yes.
My goal is not just to make as many classes as possible, but also to
use them to do rate limiting per ip per server. Say, I have a list of
10000 IPs and more than 100 servers. So simply if I want few IPs to
get speed of says 1Mbps per server but others say speed of 2 Mbps per
server. How can I achieve this without having 10000 x 100 classes.
These numbers can be large than this and hence I am looking for a
generic solution to this.

>
>
> >
> > One scheme can be like
> >                                       100: root qdisc
> >                                          |
> >                                        / | \
> >                                      /   |   \
> >                                    /     |     \
> >                                  /       |       \
> >                           100:1   100:2   100:3        child classes
> >                             |              |           |
> >                             |              |           |
> >                             |              |           |
> >                            1:            2:          3:     qdisc
> >                            / \           / \           / \
> >                          /     \                     /     \
> >                       1:1    1:2             3:1      3:2 leaf classes
> >
> > with all qdisc and classes defined as htb.
> >
> > Is this correct approach? Any alternative??
>
> Again, depends on what your goal is.
>
>
> >
> > Besides, in order to direct traffic to leaf classes 1:1, 1:2, 2:1,
> > 2:2, 3:1, 3:2 .... , instead of using filters I am using ipset with
> > skbprio and iptables map-set match rule.
> > But even after all this it don't work. Why?
>
> Again, the filters you use to classify the packets could only
> work for the classes on the same level, no the next level.

I am using ipset +  iptables to classify and not filters. Besides, if
tc is allowing me to define qdisc -> classes -> qdsic -> classes
(1,2,3 ...) sort of structure (ie like the one shown in ascii tree)
then how can those lowest child classes be actually used or consumed?

>
>
> Thanks.
