Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9835DD07C1
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 09:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725942AbfJIHEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 03:04:49 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41558 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfJIHEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 03:04:48 -0400
Received: by mail-wr1-f65.google.com with SMTP id q9so1313677wrm.8
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 00:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eo3iTi2J69tSTvIF8qHvE7i6mg1tOQt2F+9HF45pXCo=;
        b=0oOY0CBnGtSm/1IIVI4UQQOpV1cCLg8fD6d9L5A0PyoCsf9fBgJglxJyf3uTPOIUeN
         2+8v6ukiO7z0c7Jj45ktEhmh8OAvcVxshuFh9qXXspqvAiIDL2jAm/ImH5dJVMcQDYhc
         h21W44GAeHZ+KSdrN/i/AhVy6k3TgjoAOHohulhmwEQui88SKYYLARgCujTC5w3d6InO
         KDwnKoVTIKSusaPThiERPzkbfU113dPXOlNVPwzUTb5L1+2IQNDoBXvo7PBWvE6UknBI
         ET+SDkZjkeltT3l6hDNqbF4HHmBToH3if34gTJ/yKM+FuHBtpz4RdsBcpCqGy4LKWqp5
         IzIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eo3iTi2J69tSTvIF8qHvE7i6mg1tOQt2F+9HF45pXCo=;
        b=rKzX3hPE8TMzi3tl5yChRru/mN26UDFJlFhkuGqH7zzKAcnWlPafp5dEZY30MSATTm
         rbexxJ/PkBeB63Uozh9Zhmqfg8V2A13IALkqUMgdVuGWpXx7Cb/7ds9awqTaaPmm1j64
         +RAZm4cNdK7wpQv/OC8kpwPzMlAv+TGX687LxQimEERPSppKt3zjGxw/nZ8cBhR0KTvE
         PcgDm/UVcV6TqzGCBrtxSaTfMZzLfJf2jxsY8OtnRYOfX4O6Qc0sStLdbuUWoWCc0bx1
         UftVeJ8XR/C7j2mX3cTm7SU6GYbF+F6blMuW0plk4aqCmhPvBCOMxS6kqhSy5fOHBpwR
         9UNg==
X-Gm-Message-State: APjAAAWIZwo7qHwlV/QcuyNzOCUdYUsQCnefEchgw5v9fTA0xTJsK/LM
        Uyp/LXJCKpwW+HApgbLTeerZaQ==
X-Google-Smtp-Source: APXvYqxyUYDXlEy5HrlM/w5iJcXLATWxG1jUPNxNT8xHBe7ifjh/eo6tDpQv0c/sXh09AkQvu5uklw==
X-Received: by 2002:adf:9403:: with SMTP id 3mr1635550wrq.281.1570604684123;
        Wed, 09 Oct 2019 00:04:44 -0700 (PDT)
Received: from localhost (ip-213-220-235-50.net.upcbroadband.cz. [213.220.235.50])
        by smtp.gmail.com with ESMTPSA id t203sm1148379wmf.42.2019.10.09.00.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 00:04:42 -0700 (PDT)
Date:   Wed, 9 Oct 2019 09:04:42 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Ray Jui <ray.jui@broadcom.com>,
        Jiri Pirko <jiri@mellanox.com>, ayal@mellanox.com,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [PATCH net-next v2 14/22] bnxt_en: Add new FW
 devlink_health_reporter
Message-ID: <20191009070442.GF2326@nanopsycho>
References: <1567137305-5853-1-git-send-email-michael.chan@broadcom.com>
 <1567137305-5853-15-git-send-email-michael.chan@broadcom.com>
 <20191007095623.GA2326@nanopsycho>
 <CAACQVJrBLsdnQKcOzWD5UNydFGoBHus1V_2Xxm=yL1zMb_KBQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAACQVJrBLsdnQKcOzWD5UNydFGoBHus1V_2Xxm=yL1zMb_KBQA@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Oct 09, 2019 at 06:55:45AM CEST, vasundhara-v.volam@broadcom.com wrote:
>On Mon, Oct 7, 2019 at 3:26 PM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Fri, Aug 30, 2019 at 05:54:57AM CEST, michael.chan@broadcom.com wrote:
>> >From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
>> >
>> >Create new FW devlink_health_reporter, to know the current health
>> >status of FW.
>> >
>> >Command example and output:
>> >$ devlink health show pci/0000:af:00.0 reporter fw
>> >
>> >pci/0000:af:00.0:
>> >  name fw
>> >    state healthy error 0 recover 0
>> >
>> > FW status: Healthy; Reset count: 1
>>
>> I'm puzzled how did you get this output, since you put "FW status" into
>> "diagnose" callback fmsg and that is called upon "devlink health diagnose".
>>
>> [...]
>Jiri, you are right last line is output of diagnose command. Command
>is missing here.
>
>$ devlink health diagnose pci/0000:af:00.0 reporter fw
> FW status: Healthy; Reset count: 0
>
>>
>> >+static int bnxt_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
>> >+                                   struct devlink_fmsg *fmsg)
>> >+{
>> >+      struct bnxt *bp = devlink_health_reporter_priv(reporter);
>> >+      struct bnxt_fw_health *health = bp->fw_health;
>> >+      u32 val, health_status;
>> >+      int rc;
>> >+
>> >+      if (!health || test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
>> >+              return 0;
>> >+
>> >+      val = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
>> >+      health_status = val & 0xffff;
>> >+
>> >+      if (health_status == BNXT_FW_STATUS_HEALTHY) {
>> >+              rc = devlink_fmsg_string_pair_put(fmsg, "FW status",
>> >+                                                "Healthy;");
>>
>> First of all, the ";" is just wrong. You should put plain string if
>> anything. You are trying to format user output here. Don't do that
>> please.
>>
>> Please see json output:
>> $ devlink health show pci/0000:af:00.0 reporter fw -j -p
>>
>> Please remove ";" from the strings.
>Okay, I will send a patch for removing ";"
>
>>
>>
>> Second, I do not understand why you need this "FW status" at all. The
>> reporter itself has state healthy/error:
>> pci/0000:af:00.0:
>>   name fw
>>     state healthy error 0 recover 0
>>           ^^^^^^^
>>
>> "FW" is redundant of course as the reporter name is "fw".
>>
>> Please remove "FW status" and replace with some pair indicating the
>> actual error state.
>Okay, I can rename to "Status description" so that "FW" name will not
>be repeated.

Also please remove the redundant "Healthy" information. That is an
attribute of the reporter itself.


>
>>
>> In mlx5 they call it "Description".
>>
>>
>> >+              if (rc)
>> >+                      return rc;
>> >+      } else if (health_status < BNXT_FW_STATUS_HEALTHY) {
>> >+              rc = devlink_fmsg_string_pair_put(fmsg, "FW status",
>> >+                                                "Not yet completed initialization;");
>> >+              if (rc)
>> >+                      return rc;
>> >+      } else if (health_status > BNXT_FW_STATUS_HEALTHY) {
>> >+              rc = devlink_fmsg_string_pair_put(fmsg, "FW status",
>> >+                                                "Encountered fatal error and cannot recover;");
>> >+              if (rc)
>> >+                      return rc;
>> >+      }
>> >+
>> >+      if (val >> 16) {
>> >+              rc = devlink_fmsg_u32_pair_put(fmsg, "Error", val >> 16);
>>
>> Perhaps rather call this "Error code"?
>Okay.
>
>>
>>
>> >+              if (rc)
>> >+                      return rc;
>> >+      }
>> >+
>> >+      val = bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
>> >+      rc = devlink_fmsg_u32_pair_put(fmsg, "Reset count", val);
>>
>> What is this counter counting? Number of recoveries?
>> If so, that is also already counted internally by devlink.
>"Reset count" is the counter that displays the number of times
>firmware has gone for
>reset through different mechanisms and devlink is one of it. Firmware
>could have gone
>for a reset through other tools as well.
>
>Driver gets the information from firmware health register, when
>diagnose command is invoked.

okay, sounds sane.
Thanks!

>
>>
>> [...]
