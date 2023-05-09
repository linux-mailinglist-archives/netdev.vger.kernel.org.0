Return-Path: <netdev+bounces-1165-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F2C86FC684
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:36:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3AB4281380
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E46731096E;
	Tue,  9 May 2023 12:36:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51BB8BE3
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 12:36:21 +0000 (UTC)
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1603B18C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 05:36:20 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id d75a77b69052e-3f38a9918d1so128371cf.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 05:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683635779; x=1686227779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UI2kxJut4la4Iq39UjVfakKVCiv4MG6ksB/Op8AoNhk=;
        b=udTm0GJGEY+AAFYQ8FdukbenoN+h13g0ZkILjRTnWT++To5LW6DTlxb6Rjll/J2fsE
         897RSknMVBw3cQNs2bU9ds+lXDrvomSnMSCzVX/n+oOoXSRkzbfCbV3WB034AtGbMD3U
         Rnp1RsypZeqoenMR20v2LAwwQw6yjjTRKj90D4ObEp8uFifexbyhcggLCy1yt3Xk4yvL
         1MBuYhQOuDrlv+TLFEQCCfhdi06DyCwHhLghkHk+/lvc+dMHdEdKeLH4jrJJGEZqUSq2
         OfbGHOHO7LtOylMNOTjKl24wUEEi6mCs/LNDxxeqHU77VgdKbLg1f40AHTrXd6R1uFma
         /brg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683635779; x=1686227779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UI2kxJut4la4Iq39UjVfakKVCiv4MG6ksB/Op8AoNhk=;
        b=TlhgNpZVB+oCeebmkGvplhMd4MpLyOVrGwWcIZRKllr5zQizqTwybA//d8IDEwumeW
         zY8oRhVMMrcGBmCXId+6QazXl7kNMsZqiN+pxGzqyn4ZIm1pv0XVcpBLTQvUm0qgInlr
         wtdVh4ZkBJW3Uak1hp+cURPv0eLgOcbQ1I2rjDcImW1Hu3KlIwGeu1ZZJWC1EqK+3Bre
         lAHfyAXUSoVZ+7hXWDCa8AvpB3wZAn+J1twnP3QaY5k9HaCeK1ylkH8V2HDYc3puY7kD
         0H8D1YX/1u/2mlBAekBl4W7eJKkJs1gAhxLgI1d2EFxtySDMLIAKl/AE0FqvCQZ32ULP
         3m0Q==
X-Gm-Message-State: AC+VfDyp6bRy7vvwr10KAGUc7Js0GIEgh/TSOh4AwxYse/d8+zFHM+lQ
	/Mn4F7PvjL3krQXmToxxBfBIYzzRlzuCM66/rtR9yYNPRbNtCnHhRuzHNg==
X-Google-Smtp-Source: ACHHUZ76ucrDf8EBxf5O4HfpvSZy3yYhb8H1jVuyyQ38MZ0/ig0tIoXkleTv62rJW6hHmquuxWdpu/jO7Wm9XaQG/H8=
X-Received: by 2002:a05:622a:1822:b0:3f3:9b0b:8750 with SMTP id
 t34-20020a05622a182200b003f39b0b8750mr158786qtc.17.1683635778964; Tue, 09 May
 2023 05:36:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <371A6638-8D92-4891-8DF5-C0EA4FBC1977@gmail.com>
 <ZFoeZLOZbNZPUfcg@shredder> <CANn89i+=gWwebCHk2qwu12qC+yXTFUqOxWTfnqbJOAFjidcYeg@mail.gmail.com>
 <A4F00E57-AB0E-4211-B9E4-225093EB101F@gmail.com>
In-Reply-To: <A4F00E57-AB0E-4211-B9E4-225093EB101F@gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 9 May 2023 14:36:06 +0200
Message-ID: <CANn89iKOm2WPoemiqCsWaMXMyGf9C5xXH=NaSidPSNCpKxf_jQ@mail.gmail.com>
Subject: Re: Very slow remove interface from kernel
To: Martin Zaharinov <micron10@gmail.com>
Cc: Ido Schimmel <idosch@idosch.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 9, 2023 at 1:10=E2=80=AFPM Martin Zaharinov <micron10@gmail.com=
> wrote:
>
> Hi
>
> in short, there is no way to make the kernel do it faster.

Make sure your kernel does not include options you do not need.

>
> Before time with old kernel unregister device make more faster .
>
> with latest kernel >6.x this make very slow .
>

Yup, I feel your pain.

Maybe you should start a bisection then...

You might find that you have some CONFIG_ option that makes this
operation very slow.

Some layers (like hamradio and others) lack batch operations in their
netdev removal handlers.

For instance, on one machine I have access to and with my standard
.config, your benchmark gives a not too bad result with pristine
linux-6.3

modprobe dummy
ip link set dev dummy0 up
for i in $(seq 2 4094); do ip link add link dummy0 name vlan$i type
vlan id $i; done
for i in $(seq 2 4094); do ip link set dev vlan$i up; done
time for i in $(seq 2 4094); do ip link del link eth1 name vlan$i type
vlan id $i; done
real 0m55.808s
user 0m0.788s
sys 0m6.868s

Without batching, I think one netdev removal needs three synchronize_net() =
calls

I am reasonably certain numbers would not look so good if I booted a
"make allyesconfig" kernel.








>
> is there any chance to try to make this more fast.
>
>
> m.
>
>
> > On 9 May 2023, at 13:32, Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Tue, May 9, 2023 at 12:20=E2=80=AFPM Ido Schimmel <idosch@idosch.org=
> wrote:
> >>
> >> On Tue, May 09, 2023 at 11:22:13AM +0300, Martin Zaharinov wrote:
> >>> add vlans :
> >>> for i in $(seq 2 4094); do ip link add link eth1 name vlan$i type vla=
n id $i; done
> >>> for i in $(seq 2 4094); do ip link set dev vlan$i up; done
> >>>
> >>>
> >>> and after that run :
> >>>
> >>> for i in $(seq 2 4094); do ip link del link eth1 name vlan$i type vla=
n id $i; done
> >>>
> >>>
> >>> time for remove for this 4093 vlans is 5-10 min .
> >>>
> >>> Is there options to make fast this ?
> >>
> >> If you know you are going to delete all of them together, then you can
> >> add them to the same group during creation:
> >>
> >> for i in $(seq 2 4094); do ip link add link eth1 name vlan$i up group =
10 type vlan id $i; done
> >>
> >> Then delete the group:
> >>
> >> ip link del group 10
> >>
> >
> > Another way is to create a netns for retiring devices,
> > move devices to the 'retirens' when they need to go away.
> >
> > Then once per minute, delete the retirens and create a new one.
> >
> > -> This batches netdev deletions.
> >
> >
> >> IIRC, in the past there was a patchset to allow passing a list of
> >> ifindexes instead of a group number, but it never made its way upstrea=
m.
>
>

