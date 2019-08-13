Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1408BF32
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 19:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfHMRFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 13:05:04 -0400
Received: from mail-qt1-f178.google.com ([209.85.160.178]:45547 "EHLO
        mail-qt1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfHMRFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 13:05:03 -0400
Received: by mail-qt1-f178.google.com with SMTP id k13so9773882qtm.12
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 10:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=mvrLKGpp2mtd64AofLz99sdt6auHB/XguzhVuBLXR30=;
        b=Yte2RUAp0/GcteymaoEUUHQKb72+PLEblCCqFLu5ITbCmuNRkSLqVWrMRJOhPrs5wl
         44NtJbsmIAdMQStn7xyahqahJq41xLMJhXWbIrpg0iG7jmVJ9NhUF4NS7R2LlTCsFYJQ
         ZzGjVtKfC3bpeHDnZz/C6a/bL/H7zz6P8iLo+8EueXo6AsM7fSegvLcYK4kxg1ahfIcG
         mALTMwTxSyfZNExiRRYmzY+BpdKjM+54Ecet8oPoRfWHh3AdzTO+lnP9jgSXwWwqT/wO
         HPVDHVGvNotiHv40WG8ti8oeWSTaB1KnwdbyfYELgeF/oM1FTqcgWS1Pqpt8EQOxI6v0
         T6yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mvrLKGpp2mtd64AofLz99sdt6auHB/XguzhVuBLXR30=;
        b=AKTMJA2KRJ+VnN5v0cFPZWkflTVPSm5kEbOORK7ynl3/es/Bmr6uzzFVXP16mtvSi+
         noyVkf7QKN9aEZxRddyNI+NNitPI15N0NNfudtT1XX2YM8OMIzw/5OxRVwwos2rDB1DK
         W/ySs3LUvSembrLHa8HSSsVRlMyi965Cl2Bdx7c3LpBYUDVlnvZOeZdH767VeCxY6Yai
         zUeCI2fVODl0krVn9HIEmSltX3VS2KD+dtx7lqSJtY3Taoj0DnjPXrGeGDGQHSOUx44Q
         CUhjktTUWBgUi2PII/Zihq+8mpAwfmTp/qvK85nppO/N17WQh62xajEQX0ria0qyprPR
         CA7w==
X-Gm-Message-State: APjAAAXGIIGi754adsW8UqKIUox28BQ1l9sI7icLRNFH5Jpd1ghYr88W
        c2k5PYQptlMqIZvbFpwf3mX3uK31P9M=
X-Google-Smtp-Source: APXvYqzVHsKm/oZnGMabM+fQ3ekKwRFJ4yby76fbLZed1hnGFSoiaLWKay4+sjr7anjJBonoKmfj/A==
X-Received: by 2002:ac8:7094:: with SMTP id y20mr7171154qto.140.1565715903074;
        Tue, 13 Aug 2019 10:05:03 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id b18sm44654954qkc.112.2019.08.13.10.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 10:05:02 -0700 (PDT)
Date:   Tue, 13 Aug 2019 10:04:50 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        stephen@networkplumber.org, dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v3 1/3] net: devlink: allow to change
 namespaces
Message-ID: <20190813100450.55336597@cakuba.netronome.com>
In-Reply-To: <20190813061355.GF2428@nanopsycho>
References: <20190812134751.30838-1-jiri@resnulli.us>
        <20190812134751.30838-2-jiri@resnulli.us>
        <20190812182122.5bc71d30@cakuba.netronome.com>
        <20190813061355.GF2428@nanopsycho>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Aug 2019 08:13:55 +0200, Jiri Pirko wrote:
> Tue, Aug 13, 2019 at 03:21:22AM CEST, jakub.kicinski@netronome.com wrote:
> >On Mon, 12 Aug 2019 15:47:49 +0200, Jiri Pirko wrote:  
> >> @@ -6953,9 +7089,33 @@ int devlink_compat_switch_id_get(struct net_device *dev,
> >>  	return 0;
> >>  }
> >>  
> >> +static void __net_exit devlink_pernet_exit(struct net *net)
> >> +{
> >> +	struct devlink *devlink;
> >> +
> >> +	mutex_lock(&devlink_mutex);
> >> +	list_for_each_entry(devlink, &devlink_list, list)
> >> +		if (net_eq(devlink_net(devlink), net))
> >> +			devlink_netns_change(devlink, &init_net);
> >> +	mutex_unlock(&devlink_mutex);
> >> +}  
> >
> >Just to be sure - this will not cause any locking issues?
> >Usually the locking order goes devlink -> rtnl  
> 
> rtnl is not taken. Do I miss something?

Probably not, just double checking.
