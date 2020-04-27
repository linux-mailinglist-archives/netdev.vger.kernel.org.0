Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE8E71B9557
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 05:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgD0DNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 23:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725788AbgD0DNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 23:13:38 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8059BC061A0F;
        Sun, 26 Apr 2020 20:13:37 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id z2so17261362iol.11;
        Sun, 26 Apr 2020 20:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=cXxBdsHHbib8hvcuIBuvDGl4X2Uqhyu/nNTS/7HyUX8=;
        b=lxZ9NMpSFJ7Zst+PtCQXPzedzP6C3eiXaqGYwm9rdnIP2IcypA6TbggpE2id2Aj6Ml
         MozOx9KiqbnjMf6tgz24dRfsADhpIkc0p6a0ZO3+Iz1Fnwo0Z//czK9vuXhseOUO9d0J
         shAGVWCX/eg7Ue/NxmoRSq9lRa2NJlHPqrXZWFgYhT9UeU9yE9EQBuZb6zxeyHIXSxtI
         viwCxu7OWQrLHY9vglv34fDSXCZXEQCQgnySCtnsxP4OkpXyfAMgNuhTQoZ32H9Wrawm
         VfMeOVgW7kkb5ugAnCKXGZg0WO3inK/pkWaUIXmKJloE9XUmF93/h4P4A0YzLIETy8wp
         6FDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=cXxBdsHHbib8hvcuIBuvDGl4X2Uqhyu/nNTS/7HyUX8=;
        b=rtufaXMQSefKhqy4yyPj9EmbTPBaJKH9XJqvokk1PKl6tGw38midrZOG36QkPsM8mw
         YDcZ2qzvgW7colmjJiSzplcgvQKo82s47mdusNbXiLebrIMe+FgQBlO0DponMpnO1I5G
         +BpdP+KWz//QifwJMIHcOl1nQYL+gBqbwXNwwdzSnJ2gpwKR0LPPe65gM1B8xXEpxxDC
         v/osVGApJ4kBRxipe5Qd76uTBZ1K8ZUB9QJgRPG1lPj7Kk5jk6UIaeSff89+jMiTGbR6
         gx+SpivoPnxcR1tPtCUr3iupke8Mb6wOxzn11BMssH6JbuduhlPyKiRYOhgm03lklLUf
         kaPQ==
X-Gm-Message-State: AGi0PuY/tJdewGZANbNf3rsQl1fYpPR3SDuh3zREH6uxQDI2dl3Q778d
        voz2Hh/In9VLFB1UD+L6N0mH3r2Gdb5levepJ27RjSqyVn8=
X-Google-Smtp-Source: APiQypIOFo9hgWUi1vPstyz48RY+E8kF4z0w27FtTvPWQK4InkFeJlbTLQIldSDSTbgYbnIVZkrVgxTnafFxF1OXEkU=
X-Received: by 2002:a05:6638:247:: with SMTP id w7mr18551720jaq.128.1587957216639;
 Sun, 26 Apr 2020 20:13:36 -0700 (PDT)
MIME-Version: 1.0
References: <f2729529e0ffb7b1d5212337de25b646f93133e0.camel@petri-meat.com>
In-Reply-To: <f2729529e0ffb7b1d5212337de25b646f93133e0.camel@petri-meat.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Sun, 26 Apr 2020 20:13:25 -0700
Message-ID: <CAA93jw4WTaYLQ5KmPi078z0rmPT2FyXQrFLT2FiXVx9Cq1Kokw@mail.gmail.com>
Subject: IETF meeting over the fate of the last ecn bit in the IP header this monday
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The initial debate was well covered in this lwn article:
https://lwn.net/Articles/783673/

There's been much work since, code submitted for review, lots of bugs
fixed, tons of benchmarks published by both sides, and much heat
expended on the ietf tsvwg mailing list. As the L4S proposal in
particular involves making a few deep changes to linux and the
internet itself, I would appreciate more in the linux world taking a
very hard look at both SCE (some congestion experienced) and L4S
before the standardization effort goes much further.

If anyone here would like to attend this ietf meeting, it's at 7AM
PDT, more details, and pointers to the slides, below. It's pretty
obvious which side has a marketing department!


---------- Forwarded message ---------
From: Steven Blake <slblake@petri-meat.com>
Date: Sun, Apr 26, 2020 at 6:58 PM
Subject: [tsvwg] April 27 interim meeting - links & instructions
To: <tsvwg@ietf.org>


For those who have been scouring their email archives trying to find
links to Monday's interim meeting, here they are:

WEBEX:

JOIN WEBEX MEETING
https://ietf.webex.com/ietf/j.php?MTID=3Dmed94e0e0db21d028e4f79c3b026f6d84
Meeting number (access code): 615 734 219

Meeting password: TSV703

JOIN BY PHONE
1-650-479-3208 Call-in toll number (US/Canada)
Tap here to call (mobile phones only, hosts not supported):
tel:%2B1-650-479-3208,,*01*615734219%23%23*01*
1-877-668-4493 Call-in toll free number (US/Canada)
Tap here to call (mobile phones only, hosts not supported):
tel:1-877-668-4493,,*01*615734219%23%23*01*

Global call-in numbers
https://ietf.webex.com/ietf/globalcallin.php?MTID=3Dmed1ad885f74b38fb4789b0=
ea2d6459b3

Toll-free calling restrictions
https://www.webex.com/pdf/tollfree_restrictions.pdf

JOIN FROM A VIDEO SYSTEM OR APPLICATION
Dial sip:615734219@ietf.webex.com
You can also dial 173.243.2.68 and enter your meeting number.

Join using Microsoft Lync or Microsoft Skype for Business
Dial sip:615734219.ietf@lync.webex.com

Can't join the meeting?
https://collaborationhelp.cisco.com/article/WBX000029055


Etherpad: https://etherpad.ietf.org:9009/p/notes-ietf-interim-2020-tsvwg-03=
?useMonospaceFont=3Dtrue

Jabber: xmpp:tsvwg@jabber.ietf.org?join

Meeting materials:
https://datatracker.ietf.org/meeting/interim-2020-tsvwg-03/session/tsvwg



Regards,

// Steve





--=20
Make Music, Not War

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-435-0729
