Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F64B9F1E3
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 19:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730392AbfH0Rvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 13:51:36 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43187 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728834AbfH0Rvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 13:51:36 -0400
Received: by mail-qk1-f195.google.com with SMTP id m2so17731868qkd.10;
        Tue, 27 Aug 2019 10:51:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E88YGzARmAva6Qm1H4TM6Pub6gnTfS/HLrrmcSQtAJs=;
        b=XQEJxFrH8DGzZlXHXkl3T7G4MSBGQN+42AmVGsgXrwxJcZtW4Dv1kaMMDEzxvmiSgo
         Tha7YYNrPFNnzK2VxjKJ0eTFZDzbmfV2Qb6mD9f6feI0sBzIG9gYYq/BOAx9O/UA+7S9
         hQXum+FRbSRbd9+YfwjV5DOFv4Pn38MwOMHePGzJ726SDSXcwDG29oilsO7Idvj5Z+CN
         qoMqTiEWlkjrmhxJ40Vxis4uY/xetre+bwQoFusU+z0UFoIoz+/JaDhfZugxawJDgCMc
         j6O4szT0ctlZROKFodi9+emub8t1tCKFeRnHVYr9SmqTpwduyKUBdveUII7rWpntkQZm
         ljQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E88YGzARmAva6Qm1H4TM6Pub6gnTfS/HLrrmcSQtAJs=;
        b=YG6ClZvZ3UxrW6KJVP+9yz9y9qx90ASxVCA0MtYoUJkYVplNC0CLXpKJ8AtV8DpaE9
         fj9bcM1wkr9DjjXqzTdM9ktMC7HMJl+DgbqYCp7uhG6F2tQB+bj+EPKZM9HzdjAJioWr
         /FI3UF/B/0sKB599mP2Z+uCYW0veILrOZxkxdhpp/V6LESNWZZkHnNfJa4xnyQobN03u
         XSRfan01Ugmw7IShZYvmXXWRR7rjvrBgU1xW4tQDa6SrvW1tRDc6FfPSmclZOTTFLQmP
         x1x3LcraS2XBbh4e9A0w2jGgIqcZz5Ld4YxmcvaxsLIQWZU19G0RQ5NR0CbuWPq7SYPm
         7l1g==
X-Gm-Message-State: APjAAAXLyJ8xetgeG1gncxe/Vl581saO8PsqJ/sMFwMbDrzZdXzHAguh
        XWP7O9ObCmcDQOc0sytP9rI=
X-Google-Smtp-Source: APXvYqwJoIU99Bz32G80mO+1Wy8sOWb/TpAxbkuAt6NeigKk95G3WOydrANZiDBuLOqQKZBaz026+Q==
X-Received: by 2002:ae9:ec0d:: with SMTP id h13mr20935777qkg.407.1566928295247;
        Tue, 27 Aug 2019 10:51:35 -0700 (PDT)
Received: from Davids-MacBook-Pro.local (c-73-169-115-106.hsd1.co.comcast.net. [73.169.115.106])
        by smtp.googlemail.com with ESMTPSA id b18sm25307qkc.112.2019.08.27.10.51.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 10:51:34 -0700 (PDT)
Subject: Re: [PATCH net] ipv6: Default fib6_type to RTN_UNICAST when not set
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "greg@kroah.com" <greg@kroah.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        David Miller <davem@davemloft.net>
References: <8dad6e3cf2e6cb0086b0a6f75ccdb44822a15001.camel@infinera.com>
 <20190827170729.GD21369@kroah.com>
 <db87d29f160302789f239cda2074ed35ae67da62.camel@infinera.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b644d367-53a3-c2cc-2a84-28a7caae480c@gmail.com>
Date:   Tue, 27 Aug 2019 11:51:32 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <db87d29f160302789f239cda2074ed35ae67da62.camel@infinera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/27/19 11:24 AM, Joakim Tjernlund wrote:
> On Tue, 2019-08-27 at 19:07 +0200, Greg KH wrote:
>>
>> On Tue, Aug 27, 2019 at 08:33:28AM +0000, Joakim Tjernlund wrote:
>>> I don't see the above patch in stable yet, is it still queued?
>>> https://nam03.safelinks.protection.outlook.com/?url=https%3A%2F%2Fwww.spinics.net%2Flists%2Fnetdev%2Fmsg579581.html&amp;data=02%7C01%7CJoakim.Tjernlund%40infinera.com%7Ce70efa27d90b4eecb1cf08d72b110e78%7C285643de5f5b4b03a1530ae2dc8aaf77%7C1%7C1%7C637025224574216531&amp;sdata=Mhu0BqlM21XXYdR%2BC%2F8wXrMkzBKJpKUZZZXz57sAyuQ%3D&amp;reserved=0
>>
>> Ask the network developers :)
> 
> OK, asking netdev then.
> 
>  Jocke
> 

Dave:

Specific request is for commit c7036d97acd2527cef145b5ef9ad1a37ed21bbe6
("ipv6: Default fib6_type to RTN_UNICAST when not set") to be queued for
stable releases prior to v5.2
