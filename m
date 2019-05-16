Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8BE221070
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 00:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbfEPWHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 18:07:02 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:35186 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbfEPWHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 18:07:01 -0400
Received: by mail-vs1-f66.google.com with SMTP id q13so3352521vso.2
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 15:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=98XO0M5JaJPa0Gvus+M9qYFhI5zsdOLAHRfe22rvcYw=;
        b=I86VFaXRxGWGPSivSqknXFOB3XRaCZ1J2MGBEHOTVymwlvFyvafdSbvcF2xAw8U0Ox
         9XWRfxxyO96fihz1LLKGZYEpwxt7NzKeZZD+cY/Aj6noME/C83nWZY5rbgsd3JUy5kj7
         5R5ntcCr5T2p4S3+c5xvIOOF1uFlt06b2kwQXZAVY93cnr7LjVeDEhZrZxK43tE85kkT
         n3E12BRjCxofdIGwtgC0zCQuPwktPc0Lw2uLwYsVVcIuc3qOzpCYqJO7O4wFN8/Upgf0
         gkudp3I2XPprDBWb4Ljdr6cILIbUgS3Z2JWjTqDXmLGIj4KWf4eyWgCzJh1cvJacKroO
         QBag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=98XO0M5JaJPa0Gvus+M9qYFhI5zsdOLAHRfe22rvcYw=;
        b=cjCDqGGh1O58WvFrzW0jMvh4qZgzNi+mXUpn+u0o6KcpqG+FmEPUSVbwFZzsBYUt0I
         uu4+iWApCmzBhMa3zi9LNpjBpfiCVfsuy/0+7J8+1CR6yNme+aMZ4Bz/1t/y4wmaAvyx
         D+xB04qaySFxXrZgQwtgAx7xmek4Np/z9rRMQgoXsDd7fHIG7PkcMIHqpX7zs0m4pZU8
         UKQnjnepgJvIhGqP05pYNGoYnO2L76ZHyg1Ta6uX30n9nws0F23TmuHxp28owvQHtx9s
         Yd9guKUS882AGnRvRjoYWwfrOS6x3Myu6VQ/2YRLjL+0AzlbwN7GfLa+LSh6MLcmjkvQ
         HePw==
X-Gm-Message-State: APjAAAVzRzIeirc9VKu1mCqJTzJ1T7tVGmJazt6z9Gs8NuIhrLYgDIeH
        bwvty6uQ0cL4mvoLg7KobFjBtOEemewtpwY09QRgiA==
X-Google-Smtp-Source: APXvYqyrymKYrNjwCM9EGyA3IlxSM73cM/M2ymACQbuwMzGYWwIb6sknmPW9hRyl9lDZQCXajkS+6EdlZvUavo4lL6k=
X-Received: by 2002:a67:f695:: with SMTP id n21mr24195518vso.19.1558044420593;
 Thu, 16 May 2019 15:07:00 -0700 (PDT)
MIME-Version: 1.0
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
Date:   Thu, 16 May 2019 15:06:27 -0700
Message-ID: <CAJpBn1xzkxtz=V7U=bjTpatxy5DhriHpjKJRqn2AA796jz-vNg@mail.gmail.com>
Subject: Re: [PATCH net-next RFC] Dump SW SQ context as part of tx reporter
To:     Aya Levin <ayal@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 May 2019 12:02:49 +0000, Aya Levin wrote:
> >>> Could you share the script? How is it going to be distributed?
> >> I thought that the script should be in a available on Mellanox website.
> >
> > :(
>
> Do you think it belongs under kernel/scripts?

iproute2/devlink perhaps, since it's devlink that's dumping it?
Much like we have ethtool interpret eeproms etc all in user space.
