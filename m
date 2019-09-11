Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3100AF5A8
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 08:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfIKGRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 02:17:13 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36180 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfIKGRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 02:17:13 -0400
Received: by mail-wr1-f66.google.com with SMTP id y19so23062542wrd.3
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 23:17:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qxN+8dkFqfe0AF60/knDBKIeuNy4mWomycphjD3RDTw=;
        b=D+Wi+YR3+MPanZ6Nl/E7ZAnGfs/VOgMHGOJ4q2DpSx8LOEo4buar/YN9sT3IRXwc4p
         zrW5IzTIV8g/LN+QUOmcIfjdx7b0RgwHzYDFQCBUYTHw0ttKukmKpZ1ypm9yZ5jsSxKB
         qBhhrpUCM8CmqbaNC7XhBuwC6z8fmNQIPaCIqlj0fmZfrdosMyeIThYuAOZUwQQTvFo+
         pE89Vhxi9IrRJoWfAHpbauWAnd+CeFzdEp0ClAxG0WCOjdrqxwdgR25qqvK06VXo7pNl
         pTAHdwgQ+BAMM6KnDm614G23WoEFKDXeP0jQnxtBXRYpW+HjGCcGUKKq5ieumk5nx3CW
         50Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qxN+8dkFqfe0AF60/knDBKIeuNy4mWomycphjD3RDTw=;
        b=V/pW9hiDoEOBsTMWutEb2AiG9jaf2NOE8eB+ioX6BJoaS8EFMeYHLauREC44Vl16/b
         csSdII5hE/Rd62opFEScE3EwsCmDgx+yYRtBi4W8zj5h8I3YNQjPziJffROozyDJE8vM
         xdzeJBHrQCTQXMKkcdwSx5xBkw6QxbKSzAsuEu60cTPfKnurVQjJUdoFFCnrgWz3AMuR
         0Wc8WMvPqsShLGNv6aqsA2sIi3EW9GSHFLILGrk1ABd3n039AKBFGsEOSO9YG6PEGeBg
         3m0gF4piH5EYSo2U9UN2pAcUvldZANzzaVRW3cAQ456hvPBMjyAAxZI3C06Bes81CXs+
         S6eA==
X-Gm-Message-State: APjAAAVW6Nh+G9auLEZw8cwxreEHPGEsu5iKIjB+y+qWU+9GMb9KhobL
        kE0Ip7mRdswIrnqHPkNw9B9Ky45AHCQ=
X-Google-Smtp-Source: APXvYqzOT6k/ZT/u+eQH+M3iVvZkoVZM495jjykFkKbwqA07M91HnhIotkhpBr4rWC6Hm7SNRvVZag==
X-Received: by 2002:a05:6000:1cf:: with SMTP id t15mr28035488wrx.173.1568182632020;
        Tue, 10 Sep 2019 23:17:12 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id b1sm1715639wmj.4.2019.09.10.23.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 23:17:11 -0700 (PDT)
Date:   Wed, 11 Sep 2019 08:17:10 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Tariq Toukan <tariqt@mellanox.com>, mlxsw <mlxsw@mellanox.com>
Subject: Re: [patch net-next v2 3/3] net: devlink: move reload fail
 indication to devlink core and expose to user
Message-ID: <20190911061710.GA2202@nanopsycho>
References: <20190907205400.14589-1-jiri@resnulli.us>
 <20190907205400.14589-4-jiri@resnulli.us>
 <20190908103928.GA21777@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190908103928.GA21777@splinter>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Sep 08, 2019 at 12:39:32PM CEST, idosch@mellanox.com wrote:
>On Sat, Sep 07, 2019 at 10:54:00PM +0200, Jiri Pirko wrote:
>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
>> index 546e75dd74ac..7cb5e8c5ae0d 100644
>> --- a/include/uapi/linux/devlink.h
>> +++ b/include/uapi/linux/devlink.h
>> @@ -410,6 +410,8 @@ enum devlink_attr {
>>  	DEVLINK_ATTR_TRAP_METADATA,			/* nested */
>>  	DEVLINK_ATTR_TRAP_GROUP_NAME,			/* string */
>>  
>> +	DEVLINK_ATTR_RELOAD_FAILED,			/* u8 0 or 1 */
>> +
>>  	/* add new attributes above here, update the policy in devlink.c */
>>  
>>  	__DEVLINK_ATTR_MAX,
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 1e3a2288b0b2..e00a4a643d17 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -471,6 +471,8 @@ static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
>>  
>>  	if (devlink_nl_put_handle(msg, devlink))
>>  		goto nla_put_failure;
>> +	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_FAILED, devlink->reload_failed))
>
>Why not use NLA_FLAG for this?

Bacause older kernel does not return this. So the user would not know if
everything is fine or if the kernel does not support the attribute.
Using u8 instead allows it.


>
>> +		goto nla_put_failure;
>>  
>>  	genlmsg_end(msg, hdr);
>>  	return 0;
>> @@ -2677,6 +2679,21 @@ static bool devlink_reload_supported(struct devlink *devlink)
>>  	return devlink->ops->reload_down && devlink->ops->reload_up;
>>  }
