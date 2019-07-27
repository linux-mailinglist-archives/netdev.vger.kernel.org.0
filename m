Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4398577822
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 12:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfG0KVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 06:21:19 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:40361 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbfG0KVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 06:21:19 -0400
Received: by mail-wr1-f43.google.com with SMTP id r1so56838063wrl.7
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 03:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QWZqLeMx0kzpIUzmgXbf9HfU0qmfjkWKwRYH6xIhwM0=;
        b=YCUTTzF2uDDtZLQoSt7NAvBz/ENQRzgKWrlYUs/4ZClD6/NyPL0Lmc4YRRIoOoqR1T
         nIxhfciz2jZL7nptEp9D8nLRpCEY3MnLoczeYI+nLQrrNhxPY+MyDjHHGtMfKd9VTKvd
         Te+UP/GlozGQvghzLz0MCH2rqUScKth32vatMyZWXBwPpQORhoIDJtfGZHX8s1PVBWiK
         4e6siNOpOVGZIeXHT/6owM2gLhINuskWc7WSD0uXwDeqU8hHEljGDOFYDJBEbz9R7VTV
         FKobM/sz4E/uM6kFGIeSlj2Xv2fbJyDjcFqlhQCRR9y80lrvgGR0tqg598r5WTfoRMdT
         vttQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QWZqLeMx0kzpIUzmgXbf9HfU0qmfjkWKwRYH6xIhwM0=;
        b=qhaYn9xSCN+UppI+n0tqD2OI19y9vTNx0WWs3JcTx+LDo5wR0U49fUGcAwZe4NoJNP
         /5mMZoqpIYPJwb9iwZeop53P2ivhJEfCsZ+5/BQsBw2TW3foSp7GlpSLQ66gH9k0N5A7
         j40i9sif2JUzK7bXl/upWNqHTZnys65GqrpSBmZVViBPTInMIiemFzFjbhEolIEH4AI4
         vXZetNys4ykTQAR/3wk5K1xqRxSoFj7w9jKZVirlyS//fz6YRKhygFJKm+yyQzceKAVd
         wL0FLA8TEF8uuZmGEsoUurqMNYn943xefeTtgpKpDr7HB/2OYK7qcX1ROosx1NCFeblU
         jlLw==
X-Gm-Message-State: APjAAAUfPGZAnihggG19JM+TxkDXXiZ70NjTLV7AFI4rq2zl1EJZvmIy
        mJPeXtjhyCsl7nlZCRjsQVM=
X-Google-Smtp-Source: APXvYqzqn8GScDoPbsPupdr2PFDckxSsZXNisTLisuSNdLJE7jpCKWX7FK92fFN3GfDmIBG9Yttm6A==
X-Received: by 2002:adf:eac4:: with SMTP id o4mr104949698wrn.290.1564222877893;
        Sat, 27 Jul 2019 03:21:17 -0700 (PDT)
Received: from localhost (ip-78-102-222-119.net.upcbroadband.cz. [78.102.222.119])
        by smtp.gmail.com with ESMTPSA id c65sm54491526wma.44.2019.07.27.03.21.17
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 27 Jul 2019 03:21:17 -0700 (PDT)
Date:   Sat, 27 Jul 2019 12:21:16 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, sthemmin@microsoft.com,
        dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch iproute2 1/2] devlink: introduce cmdline option to switch
 to a different namespace
Message-ID: <20190727102116.GC2843@nanopsycho>
References: <20190727094459.26345-1-jiri@resnulli.us>
 <20190727100544.28649-1-jiri@resnulli.us>
 <87ef2bwztr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ef2bwztr.fsf@toke.dk>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jul 27, 2019 at 12:12:48PM CEST, toke@redhat.com wrote:
>Jiri Pirko <jiri@resnulli.us> writes:
>
>> From: Jiri Pirko <jiri@mellanox.com>
>>
>> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>>  devlink/devlink.c  | 12 ++++++++++--
>>  man/man8/devlink.8 |  4 ++++
>>  2 files changed, 14 insertions(+), 2 deletions(-)
>>
>> diff --git a/devlink/devlink.c b/devlink/devlink.c
>> index d8197ea3a478..9242cc05ad0c 100644
>> --- a/devlink/devlink.c
>> +++ b/devlink/devlink.c
>> @@ -32,6 +32,7 @@
>>  #include "mnlg.h"
>>  #include "json_writer.h"
>>  #include "utils.h"
>> +#include "namespace.h"
>>  
>>  #define ESWITCH_MODE_LEGACY "legacy"
>>  #define ESWITCH_MODE_SWITCHDEV "switchdev"
>> @@ -6332,7 +6333,7 @@ static int cmd_health(struct dl *dl)
>>  static void help(void)
>>  {
>>  	pr_err("Usage: devlink [ OPTIONS ] OBJECT { COMMAND | help }\n"
>> -	       "       devlink [ -f[orce] ] -b[atch] filename\n"
>> +	       "       devlink [ -f[orce] ] -b[atch] filename -N[etns]
>>  netnsname\n"
>
>'ip' uses lower-case n for this; why not be consistent?

Because "n" is taken :/


>
>-Toke
