Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E169218A54
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 16:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729745AbgGHOot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 10:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729595AbgGHOos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 10:44:48 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48321C08C5CE
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 07:44:48 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id q15so3513808wmj.2
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 07:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XhjAnlDZIEYuR5nWOQ26Xfd/nf3Myskmxf7fUqB3Xt4=;
        b=0dY6oXuQZLXNjJCFEJh0g6JCLl1Ce++tIlZ4bMAcVfBj2FDzqA77rSeJWkHHqEft90
         EcPLZWP8Sp8lRldfaiJb8KhmDli2O5FqX0xIyNbR3NTTAjLDigS6YT2qfdEHINPbm5WE
         +Z5rfsjry3aSs2GbHwMoQozFmswGAlveLN114o50CZRLIANhu7Y+K4Q86NLBQZh2lbw/
         OxDrBWEd6jJcRMGjqaK7P9eMlKqV3gZTtQoeBLeAc+GrJTwPAYyCAynTsgDFzAe9mqe2
         FcJ14lqhjDyQHo94HDluMrhEX7zYe0zHzxa485XdPozIqUJHGOP0eVE1X7Dw1AVcznsA
         37Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XhjAnlDZIEYuR5nWOQ26Xfd/nf3Myskmxf7fUqB3Xt4=;
        b=UGntyy9dSt+9+e+POLxBALq9JY9soQiW+wRyFTmeV00vWPhZol0ODX84B7XJ4Sk9VX
         zvL5qNOb7p1Lu3mwpWPDNY/dW8h5Lo0zXfE05r/sD92solaQUmiT+4GlvsPBQ2RPrDx+
         xbhyokWwxhdx9cMBpJWnFuGheTtQTw4Kgly8guLtquTmEQNHx7ZjyOUuv/OrnDnaZL3E
         hY1l9xKYwuSNk0Z3ZDDZYf3lzwtcDfTZvrD7vewf1hE1zVd/QJa4YP4q+J7b2wzxtXS3
         oMOmGbU3fU9GSJj1MHz821YIY4xqHNCRjocK6XuMmQaDEq+l1lw4ZDxroArT1FbMHcT0
         lg9A==
X-Gm-Message-State: AOAM532mNu+VvKyyc5tbQTHWpO6jwWLfqZeB0BhPy4rAbXAEHhtbuSeh
        mawX3yX1okPLQ3sV4JSW0BQNuVtMxReGQg==
X-Google-Smtp-Source: ABdhPJyVXOZ12o5h6eCWqW/wy3OAUwLhKs8OFQCEqRv2HLLp1jbmZ+Lg2Do8rYQCV5iJsto3iokf5w==
X-Received: by 2002:a1c:2d4b:: with SMTP id t72mr9536117wmt.105.1594219487060;
        Wed, 08 Jul 2020 07:44:47 -0700 (PDT)
Received: from [192.168.1.12] ([194.35.118.83])
        by smtp.gmail.com with ESMTPSA id x185sm6976028wmg.41.2020.07.08.07.44.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 07:44:46 -0700 (PDT)
Subject: Re: [PATCH bpf-next] bpf: Fix another bpftool segfault without
 skeleton code enabled
To:     louis.peens@netronome.com, ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, oss-drivers@netronome.com
References: <20200708110827.7673-1-louis.peens@netronome.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <90a6acce-93f7-62df-fc96-0294cb168d64@isovalent.com>
Date:   Wed, 8 Jul 2020 15:44:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200708110827.7673-1-louis.peens@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-07-08 13:08 UTC+0200 ~ louis.peens@netronome.com
> From: Louis Peens <louis.peens@netronome.com>
> 
> emit_obj_refs_json needs to added the same as with emit_obj_refs_plain
> to prevent segfaults, similar to Commit "8ae4121bd89e bpf: Fix bpftool
> without skeleton code enabled"). See the error below:
> 
>     # ./bpftool -p prog
>     {
>         "error": "bpftool built without PID iterator support"
>     },[{
>             "id": 2,
>             "type": "cgroup_skb",
>             "tag": "7be49e3934a125ba",
>             "gpl_compatible": true,
>             "loaded_at": 1594052789,
>             "uid": 0,
>             "bytes_xlated": 296,
>             "jited": true,
>             "bytes_jited": 203,
>             "bytes_memlock": 4096,
>             "map_ids": [2,3
>     Segmentation fault (core dumped)
> 
> The same happens for ./bpftool -p map, as well as ./bpftool -j prog/map.
> 
> Fixes: d53dee3fe013 ("tools/bpftool: Show info for processes holding BPF map/prog/link/btf FDs")
> Signed-off-by: Louis Peens <louis.peens@netronome.com>
> Reviewed-by: Simon Horman <simon.horman@netronome.com>

Reviewed-by: Quentin Monnet <quentin@isovalent.com>

Thanks Louis.
