Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2C143DC5B
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 09:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhJ1Hvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 03:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhJ1Hvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 03:51:46 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED93BC061570;
        Thu, 28 Oct 2021 00:49:19 -0700 (PDT)
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1635407355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Fne1I6sZMLlmiy4nvI7nvLT9h/IwBGc2thHLPckPEso=;
        b=e+gZIM7qMOlsJl8skuf96rx/LekaJPltAErI6phbbo9R1McOCkNRbQ9L/VtylWg4lfcwtY
        n8YRDb7nn9BchfcIRreOO7y1ReM+QbYFjZ9gMvoAiGLkBQK3d/EZhQysQ8bZtS7RFjeE/m
        iTlez484XXbkXJZmvyU2d2G2Q7yoc3U=
Date:   Thu, 28 Oct 2021 07:49:15 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yajun.deng@linux.dev
Message-ID: <6da1057ad867699815cef87cb2a79057@linux.dev>
Subject: Re: [PATCH net-next] batman-adv: Fix the wrong definition
To:     "Antonio Quartulli" <a@unstable.cc>, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, sven@narfation.org
Cc:     b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <da6fa493-0911-ca3f-16c0-380bc35d8317@unstable.cc>
References: <da6fa493-0911-ca3f-16c0-380bc35d8317@unstable.cc>
 <20211028072306.1351-1-yajun.deng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

October 28, 2021 3:35 PM, "Antonio Quartulli" <a@unstable.cc> =E5=86=99=
=E5=88=B0:=0A=0A> Hi,=0A> =0A> On 28/10/2021 09:23, Yajun Deng wrote:=0A>=
 =0A>> There are three variables that are required at most,=0A>> no need =
to define four variables.=0A>> =0A>> Fixes: 0fa4c30d710d ("batman-adv: Ma=
ke sysfs support optional")=0A>> Signed-off-by: Yajun Deng <yajun.deng@li=
nux.dev>=0A> =0A> NAK.=0A> =0A> kobject_uevent_env() does not know how ma=
ny items are stored in the=0A> array and thus requires it to be NULL term=
inated.=0A> =0A> Please check the following for reference:=0A> =0A> https=
://elixir.bootlin.com/linux/v5.15-rc6/source/lib/kobject_uevent.c#L548=0A=
> =0AOh, I didn't notice there.=0A> OTOH I guess we could still use '{}' =
for the initialization.=0A> =0A> Regards,=0A> =0A> --=0A> Antonio Quartul=
li
