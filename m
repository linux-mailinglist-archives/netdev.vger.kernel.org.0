Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46D91C2715
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 22:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730945AbfI3Up5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 16:45:57 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35890 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730485AbfI3Up4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 16:45:56 -0400
Received: by mail-wm1-f65.google.com with SMTP id m18so886334wmc.1
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 13:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cTH88i9ApqzAlYR6BAYkci9T1RZmyEiqirg6TcqhzO8=;
        b=H6gIC8AhLpYzvBsOU+kMqZ2OeQCeExpaHKRJetFKqSUXba6/a5rEt/fzJxGXpZmWgU
         jK0uJw064zDgfakHzwNKrhpQi0FYsGcToItdDCZQnzKjWSvGf3BL1UM/jtNB2O/UbZ2X
         re5aTQulzkKzmLvleaj6ulluptqvxZpvYYsZn2qokq8WHXW2B34zmPFsGHbAV5pQ1pvd
         mcbJNJATPJfSUEToDHFnuAqWy3x9sr7UY7ui9On5CC5yz1pCZceGdSt7YkNJAaSCsiXe
         trgGQEDN3n66kEr9sGUdEF08unq9/UBrxVllGT2Gk8yFK+gITjBnM6GvU91gGlZ+qWvc
         oysQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cTH88i9ApqzAlYR6BAYkci9T1RZmyEiqirg6TcqhzO8=;
        b=WxFxrdzvaRZHiWm/JMYQ7+yuhndqj8+ktBhjx98eu/wI6+mbIUeaq7Kudrhtz9G8j1
         BNrUYwpqiasbZvoKkMq+gskdcgAKkg/kwwiWBeVjB6EuH8QwVAKRiDWnpmfocUYSUiok
         wi/BOKbZlnHbqxl7b+6AObPpuGhFx/gQj6XJK/PUX4J3kDAonGPijW649ptrYHpMd+Qa
         kPD/83MVMSzA17o6kf4CECoTIuE89cglavpaV2U1X1JEiOh0jfnWgDP2YpgvdHjj3C7u
         0dMFW4x3JwkIHttaLw3DzmhNp+fWX0v7cziD8uTmL27PJOr76GYkKDhbRqQcTnTKcd1f
         iPsw==
X-Gm-Message-State: APjAAAUgJF7MgXp9fPuwyIWPealL/orYzze4N9QbINEyh2Saawaq9TL9
        r/kXsA+AVnxfqYkI29wPq4VCCeI/pno=
X-Google-Smtp-Source: APXvYqzJu6SJJOt1aADljSYOHd+v6zn8Q218WDk0m0rdYqHrOv0F1ujiUakCFmElrPU67IM1lbfCxQ==
X-Received: by 2002:a1c:35c9:: with SMTP id c192mr298428wma.91.1569865911887;
        Mon, 30 Sep 2019 10:51:51 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id a13sm35873347wrf.73.2019.09.30.10.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 10:51:51 -0700 (PDT)
Date:   Mon, 30 Sep 2019 19:51:50 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        sd@queasysnail.net, sbrivio@redhat.com, pabeni@redhat.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 1/2] ip: add support for alternative name
 addition/deletion/list
Message-ID: <20190930175150.GA2235@nanopsycho>
References: <20190930094820.11281-1-jiri@resnulli.us>
 <20190930095903.11851-1-jiri@resnulli.us>
 <20190930092718.2d3a47ab@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930092718.2d3a47ab@hermes.lan>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Sep 30, 2019 at 06:27:18PM CEST, stephen@networkplumber.org wrote:
>On Mon, 30 Sep 2019 11:59:02 +0200
>Jiri Pirko <jiri@resnulli.us> wrote:
>
>> +		open_json_array(PRINT_JSON, "altnames");
>> +		for (i = RTA_DATA(proplist); RTA_OK(i, rem);
>> +		     i = RTA_NEXT(i, rem)) {
>> +			if (i->rta_type != IFLA_ALT_IFNAME)
>> +				continue;
>> +			print_string(PRINT_FP, "NULL", "%s    altname ", _SL_);
>
>You can pass real NULL versus quoted NULL when doing print to file only

Okay, will do.
