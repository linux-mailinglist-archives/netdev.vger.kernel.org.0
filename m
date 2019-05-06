Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 917A51490F
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 13:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbfEFLhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 07:37:39 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:34379 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfEFLhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 07:37:39 -0400
Received: by mail-wr1-f51.google.com with SMTP id f7so6480424wrq.1
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 04:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KsXxhbyb47eUNST4AT0EZPVEejPGf2gJjivihtJDrWo=;
        b=w8IB3tG3l5r8BWgErTJH2Q/4JfxUhmSG6eauzlNEyi+WPxx0Xqo7mKCCmLaZ+yrD9s
         N2idhmw+wmtrDCkS4ORT4iLAtJBwyp1jXXh2XYfpoI3tSaUTpR8e+LqEIRe0rBMcSRda
         h7HBFiLDE9tu7FqUHK7eHMyK0cXFzrVrfwJFFYjH9nBBpnIrLN6wZETu0ndy0dBs4Klc
         UlEpUOJWzq27fwRqb70CTwLtxzlcj4Z82SsXYzcexzlRMP5BY+peHXeew/Ilfop3djA0
         yo5hzzb3+k9ajoj3KMJNrQWScF8OBqmuO70/1U9fpRnROrdsxShCRPSTSrGVJqRIpsK7
         513A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KsXxhbyb47eUNST4AT0EZPVEejPGf2gJjivihtJDrWo=;
        b=f4rjSrQfCLYlqSA+f+hm9z+HW8b22BAMgWt4cuQ3mRS7Cg1aR7qNdZQ+dAvmG+BLPJ
         gV3F9WeKsH510jjYvMMASRIK7UKBx3ZSNc0Hw41L1FSJR4IB2b9sO1xeZ1wAduA2p/ji
         tneCTIsjKoX7zACMRjRnbJSAx2PAjZ5qRslMmcj4qCmDnZF2YSrGPvamgFgNMnem0n17
         uaaVhTfyomz1ersgNy2npGb3uOa1AeUHUCQfKrJOyRd/GpdBK8qlDSeMK1Dovabm3ob8
         0Gje9SJKqUdVPsOCAsW34iTPl1nLxG+tIqDKZHTql7ep8Gltu+mJdEi4/R32yT+V996z
         3nMQ==
X-Gm-Message-State: APjAAAVKTvGXazfGg+kBkg3SGhdNlB3i2LpRIYRWuGEjARTqoDBR2vU2
        Q2kyqfieFVA+gXUKcseCF+blPA==
X-Google-Smtp-Source: APXvYqwaNUFMIk4ma/IfGwUaioycrx7qxP8iOCKXVI2DLoWWs6LVuyqLoIsyJAuAriXgvRRgWZrJEg==
X-Received: by 2002:adf:fc42:: with SMTP id e2mr11054422wrs.1.1557142657539;
        Mon, 06 May 2019 04:37:37 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id b184sm14315640wmh.17.2019.05.06.04.37.36
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 06 May 2019 04:37:36 -0700 (PDT)
Date:   Mon, 6 May 2019 13:37:36 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [net-next 11/15] net/mlx5: Add support for FW reporter dump
Message-ID: <20190506113736.GA2280@nanopsycho>
References: <20190505003207.1353-1-saeedm@mellanox.com>
 <20190505003207.1353-12-saeedm@mellanox.com>
 <20190505154902.GF31501@nanopsycho.orion>
 <923129a3-d5e0-3b1e-932c-efdc96dba676@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <923129a3-d5e0-3b1e-932c-efdc96dba676@mellanox.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, May 06, 2019 at 12:51:24PM CEST, moshe@mellanox.com wrote:
>
>
>On 5/5/2019 6:49 PM, Jiri Pirko wrote:
>> Sun, May 05, 2019 at 02:33:27AM CEST, saeedm@mellanox.com wrote:
>>> From: Moshe Shemesh <moshe@mellanox.com>
>>>
>>> Add support of dump callback for mlx5 FW reporter.
>>> Once we trigger FW dump, the FW will write the core dump to its raw data
>>> buffer. The tracer translates the raw data to traces and save it to a
>>> buffer. Once dump is done, the saved traces data is filled as objects
>>> into the dump buffer.
>>>
>> 
>> [...]
>> 
>>> +static void mlx5_fw_tracer_save_trace(struct mlx5_fw_tracer *tracer,
>>> +				      u64 timestamp, bool lost,
>>> +				      u8 event_id, char *msg)
>>> +{
>>> +	char *saved_traces = tracer->sbuff.traces_buff;
>>> +	u32 offset;
>>> +
>>> +	mutex_lock(&tracer->sbuff.lock);
>>> +	offset = tracer->sbuff.saved_traces_index * TRACE_STR_LINE;
>>> +	snprintf(saved_traces + offset, TRACE_STR_LINE,
>>> +		 "%s [0x%llx] %d [0x%x] %s", dev_name(&tracer->dev->pdev->dev),
>>> +		 timestamp, lost, event_id, msg);
>> 
>> Please format this using fmsg helpers instead.
>> 
>
>Same here, I want to keep the format as is, not change it.

"as is" - where exactly?


>> 
>>> +
>>> +	tracer->sbuff.saved_traces_index =
>>> +		(tracer->sbuff.saved_traces_index + 1) & (SAVED_TRACES_NUM - 1);
>>> +	mutex_unlock(&tracer->sbuff.lock);
>>> +}
>> 
>> [...]
>> 
