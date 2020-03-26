Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27F77194A0C
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 22:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgCZVLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 17:11:37 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:39342 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727920AbgCZVLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 17:11:35 -0400
Received: by mail-wm1-f50.google.com with SMTP id a9so9382967wmj.4
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 14:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=M3rmlIkfcXdlzr10GCqTnWr9RYafZBOPiFCzh11JWsU=;
        b=e1vVSMd57bucZcznBLWdq9IuYzdWf2WMsdHGg0oY6QsJZ1SZ0IriyayKEbnqHEfJd3
         X2NsoI0sbqhD2/jMUYGCHXU60PDfZNPN2JBfSgFNt13+itq+L5LNtrWIQ5GASRDt59X3
         P2rJOY8JQ62fs/o33a/kXTzPNI4ZqkGiIoS83boJQmXZFNP/8JuzeeiOuE6VQsUny4sD
         ZkfM4vbs/bLFSX87obSZz4PYVNpWu+3OY9J0HJVIPHq+ZMWjBJdNlPCcOCkD6P0R/e3D
         9CJoAz+LOBovF5KXK2B4EL23KfylnPFunfcq7TjeqFeZzC41n6BJW4c9l2kGa0bR+oSE
         qCOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=M3rmlIkfcXdlzr10GCqTnWr9RYafZBOPiFCzh11JWsU=;
        b=gEft8NMyfUMdorO25jyp0b6U+D6AEnY/ZDB2vEriRObwWwYKhAkxa2eoTixLm3A5rD
         jrrX34dNAZtZRPb+HTWQAIxhp7dD/sSXFSRx1URwCyZJgoCplodKJODdhE+tDD7HbHvH
         ab6TPlWIyX8uQy/FXfbKquan78AC4+YkrKJSY1YhkgGmbfzistsaYfk2QgkrBvVX2sS4
         cekUNEa3cpJV2P7BYOjUzTSxowiTN779+Zy8+bCFom8LO6IFVmjuoPu/VJ/e+LVoEKBc
         G5MILUGXcJ09mf2JfImb8tzk+DfwnxMjYDNZrhHqeoDql+QteDtYJXG6rUREtGf90f9m
         TF2w==
X-Gm-Message-State: ANhLgQ22aH325FZXx4nESl53Nog9m4hjIyAm14FTo07b2Bn405zXSyEq
        ktQ49Ay6betlU/UEdQg3we7j8A==
X-Google-Smtp-Source: ADFU+vv0Uo1ATSgiX+grCGUXdNScdsZOJftwHCm/BLOB/wL3UlQ4byJ6QXBSUE9F9RQ9ikSopURtuQ==
X-Received: by 2002:a1c:2d04:: with SMTP id t4mr1891210wmt.89.1585257094064;
        Thu, 26 Mar 2020 14:11:34 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id c23sm5335531wrb.79.2020.03.26.14.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 14:11:33 -0700 (PDT)
Date:   Thu, 26 Mar 2020 22:11:32 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next v2 11/11] ice: add a devlink region for dumping NVM
 contents
Message-ID: <20200326211132.GB11304@nanopsycho.orion>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
 <20200326035157.2211090-12-jacob.e.keller@intel.com>
 <20200326090250.GQ11304@nanopsycho.orion>
 <47d38183-dc6b-bbe6-110a-8c870ec01769@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47d38183-dc6b-bbe6-110a-8c870ec01769@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 05:23:39PM CET, jacob.e.keller@intel.com wrote:
>
>
>On 3/26/2020 2:02 AM, Jiri Pirko wrote:
>> Thu, Mar 26, 2020 at 04:51:57AM CET, jacob.e.keller@intel.com wrote:
>>> +
>>> +Regions
>>> +=======
>>> +
>>> +The ``ice`` driver enables access to the contents of the Non Volatile Memory
>>> +flash chip via the ``nvm-flash`` region.
>>> +
>>> +Users can request an immediate capture of a snapshot via the
>>> +``DEVLINK_CMD_REGION_NEW``
>>> +
>>> +.. code:: shell
>>> +
>>> +    $ devlink region new pci/0000:01:00.0/nvm-flash snapshot 1
>>> +    $ devlink region dump pci/0000:01:00.0/nvm-flash snapshot 1
>>> +
>>> +    $ devlink region dump pci/0000:01:00.0/nvm-flash snapshot 1
>>> +    0000000000000000 0014 95dc 0014 9514 0035 1670 0034 db30
>>> +    0000000000000010 0000 0000 ffff ff04 0029 8c00 0028 8cc8
>>> +    0000000000000020 0016 0bb8 0016 1720 0000 0000 c00f 3ffc
>>> +    0000000000000030 bada cce5 bada cce5 bada cce5 bada cce5
>>> +
>>> +    $ devlink region read pci/0000:01:00.0/nvm-flash snapshot 1 address 0
>>> +        length 16
>> 
>> Don't wrap the cmdline.
>
>The devlink-region.rst file wrapped it like this..

That is quite odd. I don't think it is correct.
