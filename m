Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 426BF9E471
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 11:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729804AbfH0Jf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 05:35:29 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53393 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbfH0Jf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 05:35:29 -0400
Received: by mail-wm1-f67.google.com with SMTP id 10so2323076wmp.3
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 02:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Qpu6CEeTXHimTEaskHyLS87NQxeMFOykAdlHDliMtGk=;
        b=L1augmFNzZYX7lTL+0Q5ctyDaSMjTgGcKRn6/YTy/3y2J1rUPSSIGUr2+S0g7KQkkF
         cACNyMvUjr7YLLYFfdNCrmsMWmZuhpXJoRZUskJF+I+JAKr8yDKJPsigP1jRc79At4Vo
         zeuJrD/xFedwYmw0xNexPGw7B/vJMyYqt51uJbiLwI/r2CaqZFJRHHlYEkqfTpI0gwSx
         gHIoOAKlz4H68cNc58Bwyul7ocMUnb7debqX8jYs1S5gM7V6jjvpdqHDmLWCe0zqjLaz
         sT9Ll2ITPf+mlxtPd6g4/bNJNXI3+5aVDEHb/cZI40ZZMh5fottMllgsTwlsjfNSWwQp
         SRhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Qpu6CEeTXHimTEaskHyLS87NQxeMFOykAdlHDliMtGk=;
        b=FmAVkgc0AqPco7r+w+z4hatT3lDEh4WU+N8azJ5d6dpHhk8wXIUH7+gw+LVaBJWErc
         yPdJ+8K/iqky5q/zztpS5rkCav867wGNDRMJHO2rZzNqcdOTJ58JsQLNd9ZI1PHoYIcS
         8MgTKz4A3OqerOKTIBbVCxfXgQo3vcsKMa+qPN7g8HrouTiApilDi7/67Preny02TUxJ
         cf6AYXpOvmvMmn4pM0/bBjGgTAMLUfK5Irqvj6WFkuQ72H1AXK3yawSxiGseJssykeFM
         W++ok9ksaxjpuRNP+cZltxI+xnpX8cOPBKwDjOM07dbRVGKFXd/0jH9MBhGLHpl8dzew
         uoLg==
X-Gm-Message-State: APjAAAV9t5MMMwdqP3m8SX82Tq3qPEfqeRtoF/rpjMvQl50hSg+IWmJi
        6CrtTF8e60QLRobCybQcEZTBHQ==
X-Google-Smtp-Source: APXvYqw2dl8Ra65YWznVDRAohYt0JdtB4je+L5k8EdxTbHfy/NU575zzgGi+7dcbK3QuZPycF4keXA==
X-Received: by 2002:a1c:9855:: with SMTP id a82mr1527304wme.134.1566898527163;
        Tue, 27 Aug 2019 02:35:27 -0700 (PDT)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id s64sm5491954wmf.16.2019.08.27.02.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2019 02:35:26 -0700 (PDT)
Date:   Tue, 27 Aug 2019 11:35:25 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Miller <davem@davemloft.net>
Cc:     jakub.kicinski@netronome.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, netdev@vger.kernel.org,
        sthemmin@microsoft.com, dcbw@redhat.com, mkubecek@suse.cz,
        andrew@lunn.ch, parav@mellanox.com, saeedm@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
Message-ID: <20190827093525.GB2250@nanopsycho>
References: <20190826151552.4f1a2ad9@cakuba.netronome.com>
 <20190826.151819.804077961408964282.davem@davemloft.net>
 <20190827070808.GA2250@nanopsycho>
 <20190827.012242.418276717667374306.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827.012242.418276717667374306.davem@davemloft.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 27, 2019 at 10:22:42AM CEST, davem@davemloft.net wrote:
>From: Jiri Pirko <jiri@resnulli.us>
>Date: Tue, 27 Aug 2019 09:08:08 +0200
>
>> Okay, so if I understand correctly, on top of separate commands for
>> add/del of alternative names, you suggest also get/dump to be separate
>> command and don't fill this up in existing newling/getlink command.
>
>I'm not sure what to do yet.
>
>David has a point, because the only way these ifnames are useful is
>as ways to specify and choose net devices.  So based upon that I'm
>slightly learning towards not using separate commands.

Well yeah, one can use it to handle existing commands instead of
IFLA_NAME.

But why does it rule out separate commands? I think it is cleaner than
to put everything in poor setlink messages :/ The fact that we would
need to add "OP" to the setlink message just feels of. Other similar
needs may show up in the future and we may endup in ridiculous messages
like:

SETLINK
  IFLA_NAME eth0
  IFLA_ATLNAME_LIST (nest)
      IFLA_ALTNAME_OP add
      IFLA_ALTNAME somereallylongname 
      IFLA_ALTNAME_OP del
      IFLA_ALTNAME somereallyreallylongname 
      IFLA_ALTNAME_OP add
      IFLA_ALTNAME someotherreallylongname 
  IFLA_SOMETHING_ELSE_LIST (nest)
      IFLA_SOMETHING_ELSE_OP add
      ...
      IFLA_SOMETHING_ELSE_OP del
      ...
      IFLA_SOMETHING_ELSE_OP add
      ...

I don't know what to think about it. Rollbacks are going to be pure hell :/
