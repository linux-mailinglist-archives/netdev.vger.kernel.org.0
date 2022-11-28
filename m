Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272E263A01A
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 04:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiK1Daj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 22:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiK1Dai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 22:30:38 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC99C740;
        Sun, 27 Nov 2022 19:30:37 -0800 (PST)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4NL9vv1x6Jz67NRr;
        Mon, 28 Nov 2022 11:30:19 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 28 Nov 2022 04:30:35 +0100
Received: from [10.122.132.241] (10.122.132.241) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Mon, 28 Nov 2022 03:30:34 +0000
Message-ID: <f1302c1e-b870-34d2-081d-5e7f1d3ca66b@huawei.com>
Date:   Mon, 28 Nov 2022 06:30:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v8 05/12] landlock: Refactor unmask_layers() and
 init_layer_masks()
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <artem.kuzin@huawei.com>
References: <20221021152644.155136-1-konstantin.meskhidze@huawei.com>
 <20221021152644.155136-6-konstantin.meskhidze@huawei.com>
 <e41a4564-0c5c-b72f-93b6-48109c827285@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <e41a4564-0c5c-b72f-93b6-48109c827285@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhrpeml100003.china.huawei.com (7.191.160.210) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/17/2022 9:42 PM, Mickaël Salaün пишет:
> 
> On 21/10/2022 17:26, Konstantin Meskhidze wrote:
>> Adds new key_type argument to init_layer_masks() helper.
> 
> Add a new key_type argument to the…
> 
>> Adds masks_array_size argument  to unmask_layers() helper.
> 
> Add a masks_array_size argument to the…
> 
> 
> The name of these helpers need to be prefixed with "landlock_".
> 
> 
  Thanks. Will be Fixed.

>> These modifications support implementing new rule types in the next
>> Landlock versions.
>> 
>> Co-developed-by: Mickaël Salaün <mic@digikod.net>
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>

   Got it.
> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v7:
>> * Refactors commit message, adds a co-developer.
>> * Minor fixes.
>> 
>> Changes since v6:
>> * Removes masks_size attribute from init_layer_masks().
>> * Refactors init_layer_masks() with new landlock_key_type.
>> 
>> Changes since v5:
>> * Splits commit.
>> * Formats code with clang-format-14.
>> 
>> Changes since v4:
>> * Refactors init_layer_masks(), get_handled_accesses()
>> and unmask_layers() functions to support multiple rule types.
>> * Refactors landlock_get_fs_access_mask() function with
>> LANDLOCK_MASK_ACCESS_FS mask.
>> 
>> Changes since v3:
>> * Splits commit.
>> * Refactors landlock_unmask_layers functions.
>> 
>> ---
>>   security/landlock/fs.c      | 36 ++++++++++++++++++-------------
>>   security/landlock/ruleset.c | 42 ++++++++++++++++++++++++++-----------
>>   security/landlock/ruleset.h | 11 +++++-----
>>   3 files changed, 58 insertions(+), 31 deletions(-)
>> 
>> diff --git a/security/landlock/fs.c b/security/landlock/fs.c
>> index 240e42a8f788..fe76a11483f8 100644
>> --- a/security/landlock/fs.c
>> +++ b/security/landlock/fs.c
>> @@ -435,16 +435,20 @@ static bool is_access_to_paths_allowed(
>>   	if (unlikely(dentry_child1)) {
>>   		unmask_layers(find_rule(domain, dentry_child1),
>>   			      init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
>> -					       &_layer_masks_child1),
>> -			      &_layer_masks_child1);
>> +					       &_layer_masks_child1,
>> +					       LANDLOCK_KEY_INODE),
>> +			      &_layer_masks_child1,
>> +			      ARRAY_SIZE(_layer_masks_child1));
>>   		layer_masks_child1 = &_layer_masks_child1;
>>   		child1_is_directory = d_is_dir(dentry_child1);
>>   	}
>>   	if (unlikely(dentry_child2)) {
>>   		unmask_layers(find_rule(domain, dentry_child2),
>>   			      init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
>> -					       &_layer_masks_child2),
>> -			      &_layer_masks_child2);
>> +					       &_layer_masks_child2,
>> +					       LANDLOCK_KEY_INODE),
>> +			      &_layer_masks_child2,
>> +			      ARRAY_SIZE(_layer_masks_child2));
>>   		layer_masks_child2 = &_layer_masks_child2;
>>   		child2_is_directory = d_is_dir(dentry_child2);
>>   	}
>> @@ -496,15 +500,16 @@ static bool is_access_to_paths_allowed(
>>   		}
>> 
>>   		rule = find_rule(domain, walker_path.dentry);
>> -		allowed_parent1 = unmask_layers(rule, access_masked_parent1,
>> -						layer_masks_parent1);
>> -		allowed_parent2 = unmask_layers(rule, access_masked_parent2,
>> -						layer_masks_parent2);
>> +		allowed_parent1 = unmask_layers(
>> +			rule, access_masked_parent1, layer_masks_parent1,
>> +			ARRAY_SIZE(*layer_masks_parent1));
>> +		allowed_parent2 = unmask_layers(
>> +			rule, access_masked_parent2, layer_masks_parent2,
>> +			ARRAY_SIZE(*layer_masks_parent2));
>> 
>>   		/* Stops when a rule from each layer grants access. */
>>   		if (allowed_parent1 && allowed_parent2)
>>   			break;
>> -
>>   jump_up:
>>   		if (walker_path.dentry == walker_path.mnt->mnt_root) {
>>   			if (follow_up(&walker_path)) {
>> @@ -543,7 +548,8 @@ static inline int check_access_path(const struct landlock_ruleset *const domain,
>>   {
>>   	layer_mask_t layer_masks[LANDLOCK_NUM_ACCESS_FS] = {};
>> 
>> -	access_request = init_layer_masks(domain, access_request, &layer_masks);
>> +	access_request = init_layer_masks(domain, access_request, &layer_masks,
>> +					  LANDLOCK_KEY_INODE);
>>   	if (is_access_to_paths_allowed(domain, path, access_request,
>>   				       &layer_masks, NULL, 0, NULL, NULL))
>>   		return 0;
>> @@ -630,7 +636,7 @@ static bool collect_domain_accesses(
>>   		return true;
>> 
>>   	access_dom = init_layer_masks(domain, LANDLOCK_MASK_ACCESS_FS,
>> -				      layer_masks_dom);
>> +				      layer_masks_dom, LANDLOCK_KEY_INODE);
>> 
>>   	dget(dir);
>>   	while (true) {
>> @@ -638,7 +644,8 @@ static bool collect_domain_accesses(
>> 
>>   		/* Gets all layers allowing all domain accesses. */
>>   		if (unmask_layers(find_rule(domain, dir), access_dom,
>> -				  layer_masks_dom)) {
>> +				  layer_masks_dom,
>> +				  ARRAY_SIZE(*layer_masks_dom))) {
>>   			/*
>>   			 * Stops when all handled accesses are allowed by at
>>   			 * least one rule in each layer.
>> @@ -754,7 +761,7 @@ static int current_check_refer_path(struct dentry *const old_dentry,
>>   		 */
>>   		access_request_parent1 = init_layer_masks(
>>   			dom, access_request_parent1 | access_request_parent2,
>> -			&layer_masks_parent1);
>> +			&layer_masks_parent1, LANDLOCK_KEY_INODE);
>>   		if (is_access_to_paths_allowed(
>>   			    dom, new_dir, access_request_parent1,
>>   			    &layer_masks_parent1, NULL, 0, NULL, NULL))
>> @@ -1131,7 +1138,8 @@ static int hook_file_open(struct file *const file)
>> 
>>   	if (is_access_to_paths_allowed(
>>   		    dom, &file->f_path,
>> -		    init_layer_masks(dom, full_access_request, &layer_masks),
>> +		    init_layer_masks(dom, full_access_request, &layer_masks,
>> +				     LANDLOCK_KEY_INODE),
>>   		    &layer_masks, NULL, 0, NULL, NULL)) {
>>   		allowed_access = full_access_request;
>>   	} else {
>> diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
>> index 02ab14439c43..c7cf54ba4f6d 100644
>> --- a/security/landlock/ruleset.c
>> +++ b/security/landlock/ruleset.c
>> @@ -576,13 +576,15 @@ landlock_find_rule(const struct landlock_ruleset *const ruleset,
>>   /*
>>    * @layer_masks is read and may be updated according to the access request and
>>    * the matching rule.
>> + * @masks_array_size must be equal to ARRAY_SIZE(*layer_masks).
>>    *
>>    * Returns true if the request is allowed (i.e. relevant layer masks for the
>>    * request are empty).
>>    */
>>   bool unmask_layers(const struct landlock_rule *const rule,
>>   		   const access_mask_t access_request,
>> -		   layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
>> +		   layer_mask_t (*const layer_masks)[],
>> +		   const size_t masks_array_size)
>>   {
>>   	size_t layer_level;
>> 
>> @@ -614,8 +616,7 @@ bool unmask_layers(const struct landlock_rule *const rule,
>>   		 * requested access.
>>   		 */
>>   		is_empty = true;
>> -		for_each_set_bit(access_bit, &access_req,
>> -				 ARRAY_SIZE(*layer_masks)) {
>> +		for_each_set_bit(access_bit, &access_req, masks_array_size) {
>>   			if (layer->access & BIT_ULL(access_bit))
>>   				(*layer_masks)[access_bit] &= ~layer_bit;
>>   			is_empty = is_empty && !(*layer_masks)[access_bit];
>> @@ -626,6 +627,10 @@ bool unmask_layers(const struct landlock_rule *const rule,
>>   	return false;
>>   }
>> 
>> +typedef access_mask_t
>> +get_access_mask_t(const struct landlock_ruleset *const ruleset,
>> +		  const u16 layer_level);
>> +
>>   /**
>>    * init_layer_masks - Initialize layer masks from an access request
>>    *
>> @@ -635,19 +640,33 @@ bool unmask_layers(const struct landlock_rule *const rule,
>>    * @domain: The domain that defines the current restrictions.
>>    * @access_request: The requested access rights to check.
>>    * @layer_masks: The layer masks to populate.
>> + * @key_type: The key type to switch between access masks of different types.
>>    *
>>    * Returns: An access mask where each access right bit is set which is handled
>>    * in any of the active layers in @domain.
>>    */
>> -access_mask_t
>> -init_layer_masks(const struct landlock_ruleset *const domain,
>> -		 const access_mask_t access_request,
>> -		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS])
>> +access_mask_t init_layer_masks(const struct landlock_ruleset *const domain,
>> +			       const access_mask_t access_request,
>> +			       layer_mask_t (*const layer_masks)[],
>> +			       const enum landlock_key_type key_type)
>>   {
>>   	access_mask_t handled_accesses = 0;
>> -	size_t layer_level;
>> +	size_t layer_level, num_access;
>> +	get_access_mask_t *get_access_mask;
>> +
>> +	switch (key_type) {
>> +	case LANDLOCK_KEY_INODE:
>> +		get_access_mask = landlock_get_fs_access_mask;
>> +		num_access = LANDLOCK_NUM_ACCESS_FS;
>> +		break;
>> +	default:
>> +		WARN_ON_ONCE(1);
>> +		return 0;
>> +	}
>> +
>> +	memset(layer_masks, 0,
>> +	       array_size(sizeof((*layer_masks)[0]), num_access));
>> 
>> -	memset(layer_masks, 0, sizeof(*layer_masks));
>>   	/* An empty access request can happen because of O_WRONLY | O_RDWR. */
>>   	if (!access_request)
>>   		return 0;
>> @@ -657,14 +676,13 @@ init_layer_masks(const struct landlock_ruleset *const domain,
>>   		const unsigned long access_req = access_request;
>>   		unsigned long access_bit;
>> 
>> -		for_each_set_bit(access_bit, &access_req,
>> -				 ARRAY_SIZE(*layer_masks)) {
>> +		for_each_set_bit(access_bit, &access_req, num_access) {
>>   			/*
>>   			 * Artificially handles all initially denied by default
>>   			 * access rights.
>>   			 */
>>   			if (BIT_ULL(access_bit) &
>> -			    (landlock_get_fs_access_mask(domain, layer_level) |
>> +			    (get_access_mask(domain, layer_level) |
>>   			     ACCESS_INITIALLY_DENIED)) {
>>   				(*layer_masks)[access_bit] |=
>>   					BIT_ULL(layer_level);
>> diff --git a/security/landlock/ruleset.h b/security/landlock/ruleset.h
>> index 50baff4fcbb4..d9eb79ea9a89 100644
>> --- a/security/landlock/ruleset.h
>> +++ b/security/landlock/ruleset.h
>> @@ -259,11 +259,12 @@ landlock_get_fs_access_mask(const struct landlock_ruleset *const ruleset,
>> 
>>   bool unmask_layers(const struct landlock_rule *const rule,
>>   		   const access_mask_t access_request,
>> -		   layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
>> +		   layer_mask_t (*const layer_masks)[],
>> +		   const size_t masks_array_size);
>> 
>> -access_mask_t
>> -init_layer_masks(const struct landlock_ruleset *const domain,
>> -		 const access_mask_t access_request,
>> -		 layer_mask_t (*const layer_masks)[LANDLOCK_NUM_ACCESS_FS]);
>> +access_mask_t init_layer_masks(const struct landlock_ruleset *const domain,
>> +			       const access_mask_t access_request,
>> +			       layer_mask_t (*const layer_masks)[],
>> +			       const enum landlock_key_type key_type);
>> 
>>   #endif /* _SECURITY_LANDLOCK_RULESET_H */
>> --
>> 2.25.1
>> 
> .
