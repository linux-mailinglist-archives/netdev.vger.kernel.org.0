Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 543AB1A3C64
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 00:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgDIWZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 18:25:42 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36514 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbgDIWZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 18:25:42 -0400
Received: by mail-wr1-f67.google.com with SMTP id k1so62305wrm.3;
        Thu, 09 Apr 2020 15:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MccfOhyTEjCQk11LcpyTANm+rUI2Ir0HLmq1oYES1t8=;
        b=jZSTYj5cWjOuDjzY9YxQ6yw5V+0yA2GftC9If5kdvvu+MVxhPvT/DBvzcyxCCmQ0DQ
         Z6+d53iwYhYpIqaOeBa2FadSDWQD553A1BYMeHVQdWo4Zt+1UmLoPHe7kk911a/oCENb
         d/jU/I3FDkB0ri13IMRqiFKzvKRXuatIM10JKXRjJSvcNb6p7PJwksyGQCdiWws3d3pt
         fcbN0XOMgcH4gJMXT2u3P/o7du/STRIJsJTQMAmSahu0MucDKQ4ZUHLbKSQ0e4ov/N2h
         185xzQGqFZOath1idhPpBLmz2qrqeUrwPABpjSvqbGzLYmJjSFRPHZL4wKcLsSpdtife
         WuYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MccfOhyTEjCQk11LcpyTANm+rUI2Ir0HLmq1oYES1t8=;
        b=eezAZjXAFly9X6mANoeHGBORxdNr9+j8N+MS4na5JESECvhRtkmWubOV8kStS0K9KY
         chgXzfBjyxi3JRsZ2/vLmIavaMrmcJq+lwWdtqAeVzdPOCRI6ORamF22VKhKKk2KK1ue
         cIoKCkuN0NUMo06GFo0gL1JK+rEf8Ny7Df+SL1oXYRVty4tFm0AHB2+bGdNUHi0mcwKD
         HsFzdUFeVEdfsE6OWdB+H/bNPVJjTiI0vgrMS9nTSQ/PqHSKLitYSng65211P9DIs7yw
         q8udhwE/bWZjryJUmIiIKLk17VUJzbVqoA1i92vwRCogoxQ9Xf9PZQXACmFCHZtHE7iC
         9tFg==
X-Gm-Message-State: AGi0PuZa1kJLMNXRz1bIATyM42hOwEW4XjPua6BWzvPDV8LIZJeVv5XD
        83mcmmUqmcCy5z+Haqi5FHuZmfEL
X-Google-Smtp-Source: APiQypLoAc2QWvObz/EQoNkH6bHuUijSea5RNEf0GoFJf7+q8jpzqmikcm7GjSwdjUDAUWgtHFB33w==
X-Received: by 2002:adf:fa51:: with SMTP id y17mr1434980wrr.358.1586471138863;
        Thu, 09 Apr 2020 15:25:38 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:318a:bb40:630:49a0? (p200300EA8F296000318ABB40063049A0.dip0.t-ipconnect.de. [2003:ea:8f29:6000:318a:bb40:630:49a0])
        by smtp.googlemail.com with ESMTPSA id f141sm184001wmf.3.2020.04.09.15.25.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 15:25:38 -0700 (PDT)
Subject: Re: RFC: Handle hard module dependencies that are not symbol-based
 (r8169 + realtek)
To:     Lucas De Marchi <lucas.demarchi@intel.com>
Cc:     Jessica Yu <jeyu@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-modules@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f8e3f271-82df-165f-63f1-6df73ba3d59c@gmail.com>
 <20200409000200.2qsqcbrzcztk6gmu@ldmartin-desk1>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <6ed6259b-888d-605a-9a6f-526c18e7bb14@gmail.com>
Date:   Fri, 10 Apr 2020 00:25:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200409000200.2qsqcbrzcztk6gmu@ldmartin-desk1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.04.2020 02:02, Lucas De Marchi wrote:
> On Wed, Apr 01, 2020 at 11:20:20PM +0200, Heiner Kallweit wrote:
>> Currently we have no way to express a hard dependency that is not
>> a symbol-based dependency (symbol defined in module A is used in
>> module B). Use case:
>> Network driver ND uses callbacks in the dedicated PHY driver DP
>> for the integrated PHY (namely read_page() and write_page() in
>> struct phy_driver). If DP can't be loaded (e.g. because ND is in
>> initramfs but DP is not), then phylib will use the generic
>> PHY driver GP. GP doesn't implement certain callbacks that are
>> needed by ND, therefore ND's probe has to bail out with an error
>> once it detects that DP is not loaded.
>> We have this problem with driver r8169 having such a dependency
>> on PHY driver realtek. Some distributions have tools for
>> configuring initramfs that consider hard dependencies based on
>> depmod output. Means so far somebody can add r8169.ko to initramfs,
>> and neither human being nor machine will have an idea that
>> realtek.ko needs to be added too.
> 
> Could you expand on why softdep doesn't solve this problem
> with MODULE_SOFTDEP()
> 
> initramfs tools can already read it and modules can already expose them
> (they end up in /lib/modules/$(uname -r)/modules.softdep and modprobe
> makes use of them)
> 
Thanks for the feedback. I was under the impression that initramfs-tools
is affected, but you're right, it considers softdeps.
Therefore I checked the error reports again, and indeed they are about
Gentoo's "genkernel" tool only. See here:
https://bugzilla.kernel.org/show_bug.cgi?id=204343#c15

If most kernel/initramfs tools consider softdeps, then I don't see
a need for the proposed change. But well, everything is good for
something, and I learnt something about the structure of kmod.
Sorry for the noise.

> Lucas De Marchi
> 
Heiner

>>
>> Attached patch set (two patches for kmod, one for the kernel)
>> allows to express this hard dependency of ND from DP. depmod will
>> read this dependency information and treat it like a symbol-based
>> dependency. As a result tools e.g. populating initramfs can
>> consider the dependency and place DP in initramfs if ND is in
>> initramfs. On my system the patch set does the trick when
>> adding following line to r8169_main.c:
>> MODULE_HARDDEP("realtek");
>>
>> I'm interested in your opinion on the patches, and whether you
>> maybe have a better idea how to solve the problem.
>>
>> Heiner
> 
>> From 290e7dee9f6043d677f08dc06e612e13ee0d2d83 Mon Sep 17 00:00:00 2001
>> From: Heiner Kallweit <hkallweit1@gmail.com>
>> Date: Tue, 31 Mar 2020 23:02:47 +0200
>> Subject: [PATCH 1/2] depmod: add helper mod_add_dep_unique
>>
>> Create new helper mod_add_dep_unique(), next patch in this series will
>> also make use of it.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>> tools/depmod.c | 26 +++++++++++++++++++-------
>> 1 file changed, 19 insertions(+), 7 deletions(-)
>>
>> diff --git a/tools/depmod.c b/tools/depmod.c
>> index 875e314..5419d4d 100644
>> --- a/tools/depmod.c
>> +++ b/tools/depmod.c
>> @@ -907,23 +907,35 @@ static void mod_free(struct mod *mod)
>>     free(mod);
>> }
>>
>> -static int mod_add_dependency(struct mod *mod, struct symbol *sym)
>> +static int mod_add_dep_unique(struct mod *mod, struct mod *dep)
>> {
>>     int err;
>>
>> -    DBG("%s depends on %s %s\n", mod->path, sym->name,
>> -        sym->owner != NULL ? sym->owner->path : "(unknown)");
>> -
>> -    if (sym->owner == NULL)
>> +    if (dep == NULL)
>>         return 0;
>>
>> -    err = array_append_unique(&mod->deps, sym->owner);
>> +    err = array_append_unique(&mod->deps, dep);
>>     if (err == -EEXIST)
>>         return 0;
>>     if (err < 0)
>>         return err;
>>
>> -    sym->owner->users++;
>> +    dep->users++;
>> +
>> +    return 1;
>> +}
>> +
>> +static int mod_add_dependency(struct mod *mod, struct symbol *sym)
>> +{
>> +    int err;
>> +
>> +    DBG("%s depends on %s %s\n", mod->path, sym->name,
>> +        sym->owner != NULL ? sym->owner->path : "(unknown)");
>> +
>> +    err = mod_add_dep_unique(mod, sym->owner);
>> +    if (err <= 0)
>> +        return err;
>> +
>>     SHOW("%s needs \"%s\": %s\n", mod->path, sym->name, sym->owner->path);
>>     return 0;
>> }
>> -- 
>> 2.26.0
>>
> 
>> From b12fa0d85b21d84cdf4509c5048c67e17914eb28 Mon Sep 17 00:00:00 2001
>> From: Heiner Kallweit <hkallweit1@gmail.com>
>> Date: Mon, 30 Mar 2020 17:12:44 +0200
>> Subject: [PATCH] module: add MODULE_HARDDEP
>>
>> Currently we have no way to express a hard dependency that is not a
>> symbol-based dependency (symbol defined in module A is used in
>> module B). Use case:
>> Network driver ND uses callbacks in the dedicated PHY driver DP
>> for the integrated PHY. If DP can't be loaded (e.g. because ND
>> is in initramfs but DP is not), then phylib will load the generic
>> PHY driver GP. GP doesn't implement certain callbacks that are
>> used by ND, therefore ND's probe has to bail out with an error
>> once it detects that DP is not loaded.
>> This patch allows to express this hard dependency of ND from DP.
>> depmod will read this dependency information and treat it like
>> a symbol-based dependency. As a result tools e.g. populating
>> initramfs can consider the dependency and place DP in initramfs
>> if ND is in initramfs.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>> include/linux/module.h | 5 +++++
>> 1 file changed, 5 insertions(+)
>>
>> diff --git a/include/linux/module.h b/include/linux/module.h
>> index 1ad393e62..f38d4107f 100644
>> --- a/include/linux/module.h
>> +++ b/include/linux/module.h
>> @@ -169,6 +169,11 @@ extern void cleanup_module(void);
>>  */
>> #define MODULE_SOFTDEP(_softdep) MODULE_INFO(softdep, _softdep)
>>
>> +/* Hard module dependencies that are not code dependencies
>> + * Example: MODULE_HARDDEP("module-foo module-bar")
>> + */
>> +#define MODULE_HARDDEP(_harddep) MODULE_INFO(harddep, _harddep)
>> +
>> /*
>>  * MODULE_FILE is used for generating modules.builtin
>>  * So, make it no-op when this is being built as a module
>> -- 
>> 2.26.0
>>
> 
>> From af3a25833a160e029441eaf5a93f7c8625544296 Mon Sep 17 00:00:00 2001
>> From: Heiner Kallweit <hkallweit1@gmail.com>
>> Date: Wed, 1 Apr 2020 22:42:55 +0200
>> Subject: [PATCH 2/2] depmod: add depmod_load_harddeps
>>
>> Load explicitly declared hard dependency information from modules and
>> add it to the symbol-derived dependencies. This will allow
>> depmod-based tools to consider hard dependencies that are not code
>> dependencies.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>> tools/depmod.c | 38 ++++++++++++++++++++++++++++++++++++++
>> 1 file changed, 38 insertions(+)
>>
>> diff --git a/tools/depmod.c b/tools/depmod.c
>> index 5419d4d..5771dc9 100644
>> --- a/tools/depmod.c
>> +++ b/tools/depmod.c
>> @@ -1522,6 +1522,41 @@ static struct symbol *depmod_symbol_find(const struct depmod *depmod,
>>     return hash_find(depmod->symbols, name);
>> }
>>
>> +static void depmod_load_harddeps(struct depmod *depmod, struct mod *mod)
>> +{
>> +
>> +    struct kmod_list *l;
>> +
>> +    kmod_list_foreach(l, mod->info_list) {
>> +        const char *key = kmod_module_info_get_key(l);
>> +        const char *dep_name;
>> +        struct mod *dep;
>> +        char *value;
>> +
>> +        if (!streq(key, "harddep"))
>> +            continue;
>> +
>> +        value = strdup(kmod_module_info_get_value(l));
>> +        if (value == NULL)
>> +            return;
>> +
>> +        dep_name = strtok(value, " \t");
>> +
>> +        while (dep_name) {
>> +            dep = hash_find(depmod->modules_by_name, dep_name);
>> +            if (dep)
>> +                mod_add_dep_unique(mod, dep);
>> +            else
>> +                WRN("harddep: %s: unknown dependency %s\n",
>> +                    mod->modname, dep_name);
>> +
>> +            dep_name = strtok(NULL, " \t");
>> +        }
>> +
>> +        free(value);
>> +    }
>> +}
>> +
>> static int depmod_load_modules(struct depmod *depmod)
>> {
>>     struct mod **itr, **itr_end;
>> @@ -1569,6 +1604,9 @@ static int depmod_load_module_dependencies(struct depmod *depmod, struct mod *mo
>>     struct kmod_list *l;
>>
>>     DBG("do dependencies of %s\n", mod->path);
>> +
>> +    depmod_load_harddeps(depmod, mod);
>> +
>>     kmod_list_foreach(l, mod->dep_sym_list) {
>>         const char *name = kmod_module_dependency_symbol_get_symbol(l);
>>         uint64_t crc = kmod_module_dependency_symbol_get_crc(l);
>> -- 
>> 2.26.0
>>
> 

