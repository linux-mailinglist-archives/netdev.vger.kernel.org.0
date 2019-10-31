Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3EEEBAAB
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 00:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbfJaXlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 19:41:06 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34261 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfJaXlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 19:41:06 -0400
Received: by mail-lf1-f67.google.com with SMTP id f5so6003296lfp.1
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 16:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=HEoCd10b9lDmcs+TFGvmYwkuCCGoaE6ezTSO1/NuH5g=;
        b=ADXSHuKW+sHCQcOao+H15YCRO0mv/dnade0rGVim/0+TGLqEhsx3j3I99Ko1E1hpRX
         gsLxy5do9JfoDTgW8clO2izkUrFY9i3dhyBtJobIhTuH1B+/QjwS2my3NQWi6S0sLYyH
         RiaRrbMtz9bG7Ec2+CxB88IsX+mVboWj0a20Mw6U0a2U/poIw5r7qd9SW5Ac0FykJw7i
         HA7B58NqQbNL4Wm2AcZH6ECA+9DBnhPUd+NKFaQ0PjJK7eSAW8pCDcrHl667j2/PXlQY
         M+PrRO/0BBOCp94If/jUdgUNus9rBgB0GIWPGVn1d7Ou02ifeVX81esZTroE8IZLMXYO
         2CRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=HEoCd10b9lDmcs+TFGvmYwkuCCGoaE6ezTSO1/NuH5g=;
        b=VZPfi70IWqI0uBAQPNBuftFayRKVZbnJ4pxkqy3L2jpEMz9viLEdz+7IeV8z9Z/UwO
         2F4nL0wggowrlR7FO4IPHShuZo8BvDUVGE6+FU2S++YO5h++SpaAtFaxHAFP6uxSpcpV
         jbT2zVrSQFVvkm+a9GpTiCEKCnjpEVoZRGg/Lf4W7HGJbVxWquaeaB2AmLFjaf/hO0x7
         7zamznq5nH0jP53UkFm4yYLHrUIZ5q/VNWQESQyCzF0MJAcq8d9ER7mUq/FcSsPJcuzj
         c09QyuPFsBFMYq0bH7R/yI9NwtZC+rJ7eKkwZA3RHJ/UU3C1gcwECIDUJeqHYfPiMHRm
         Hk7Q==
X-Gm-Message-State: APjAAAWnLn5/GXUbOzMxw+su9NZgHGPtfDMTuhNaCCpWAppa/J9bQQIR
        oZrfInTRSaG9c8iLQfQkeJajBg==
X-Google-Smtp-Source: APXvYqxeaurvKLeFijgNVGy2z586uMKzfGXH7JLQuLXVw3Mv5Yh6C7YNDi55mmapLYmj19NK5FlHrA==
X-Received: by 2002:a19:ad4a:: with SMTP id s10mr5135864lfd.159.1572565264555;
        Thu, 31 Oct 2019 16:41:04 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r12sm4623803lfp.63.2019.10.31.16.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 16:41:04 -0700 (PDT)
Date:   Thu, 31 Oct 2019 16:40:57 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, shuah@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, rong.a.chen@intel.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next] selftests: bpf: don't try to read files
 without read permission
Message-ID: <20191031164057.6c1b486a@cakuba.netronome.com>
In-Reply-To: <20191031163535.2737f250@cakuba.netronome.com>
References: <20191015100057.19199-1-jiri@resnulli.us>
        <20191031163535.2737f250@cakuba.netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Oct 2019 16:35:35 -0700, Jakub Kicinski wrote:
> On Tue, 15 Oct 2019 12:00:56 +0200, Jiri Pirko wrote:
> > From: Jiri Pirko <jiri@mellanox.com>
> > 
> > Recently couple of files that are write only were added to netdevsim
> > debugfs. Don't read these files and avoid error.
> > 
> > Reported-by: kernel test robot <rong.a.chen@intel.com>
> > Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> > ---
> >  tools/testing/selftests/bpf/test_offload.py | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/bpf/test_offload.py b/tools/testing/selftests/bpf/test_offload.py
> > index 15a666329a34..c44c650bde3a 100755
> > --- a/tools/testing/selftests/bpf/test_offload.py
> > +++ b/tools/testing/selftests/bpf/test_offload.py
> > @@ -312,7 +312,7 @@ class DebugfsDir:
> >              if f == "ports":
> >                  continue
> >              p = os.path.join(path, f)
> > -            if os.path.isfile(p):
> > +            if os.path.isfile(p) and os.access(p, os.R_OK):  
> 
> Have you tested this? Looks like python always returns True here when
> run as root, and this script requires root (and checks for it).

Yeah, you definitely haven't tested this. Even if it worked we'd fall
into the else condition and say:

Exception: /sys/kernel/debug/netdevsim/netdevsim0//ports/0/dev/take_snapshot is neither file nor directory

> Also the fix is needed in net, not sure why you sent it to net-next.
> 
> >                  _, out = cmd('cat %s/%s' % (path, f))
> >                  dfs[f] = out.strip()
> >              elif os.path.isdir(p):  

